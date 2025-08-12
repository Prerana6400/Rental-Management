const express = require('express');
const Payment = require('../models/Payment');
const Rental = require('../models/Rental');
const Invoice = require('../models/Invoice');
const { protect, authorize } = require('../middleware/auth');
const paytmService = require('../services/paytmService');
const stripeService = require('../services/stripeService');
const router = express.Router();

// @desc    Create Stripe payment intent
// @route   POST /api/payments/stripe/create-payment-intent
// @access  Private
const createStripePaymentIntent = async (req, res) => {
  try {
    const { rentalId, amount, paymentType, customerDetails } = req.body;

    if (!rentalId || !amount || !paymentType) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: rentalId, amount, paymentType'
      });
    }

    // Find the rental
    const rental = await Rental.findById(rentalId);
    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Verify the rental belongs to the user
    if (rental.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. This rental does not belong to you.'
      });
    }

    // Create or get Stripe customer
    let customerResult = await stripeService.createCustomer(
      customerDetails.email,
      customerDetails.name,
      customerDetails.phone
    );

    if (!customerResult.success) {
      return res.status(400).json({
        success: false,
        message: 'Failed to create customer: ' + customerResult.message
      });
    }

    // Create payment intent
    const paymentIntentResult = await stripeService.createPaymentIntent(
      amount,
      'inr',
      {
        rentalId: rentalId,
        userId: req.user.id,
        paymentType: paymentType,
        customerId: customerResult.data.customerId
      }
    );

    if (!paymentIntentResult.success) {
      return res.status(400).json({
        success: false,
        message: 'Failed to create payment intent: ' + paymentIntentResult.message
      });
    }

    res.json({
      success: true,
      message: 'Stripe payment intent created successfully',
      data: {
        clientSecret: paymentIntentResult.data.clientSecret,
        paymentIntentId: paymentIntentResult.data.paymentIntentId,
        customerId: customerResult.data.customerId
      }
    });
  } catch (error) {
    console.error('Stripe payment intent creation error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while creating payment intent'
    });
  }
};

// @desc    Confirm Stripe payment
// @route   POST /api/payments/stripe/confirm-payment
// @access  Private
const confirmStripePayment = async (req, res) => {
  try {
    const { rentalId, paymentIntentId, paymentType, amount } = req.body;

    if (!rentalId || !paymentIntentId || !paymentType || !amount) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: rentalId, paymentIntentId, paymentType, amount'
      });
    }

    // Find the rental
    const rental = await Rental.findById(rentalId);
    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Verify the rental belongs to the user
    if (rental.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. This rental does not belong to you.'
      });
    }

    // Confirm payment with Stripe
    const confirmationResult = await stripeService.confirmPaymentIntent(paymentIntentId);
    
    if (!confirmationResult.success) {
      return res.status(400).json({
        success: false,
        message: 'Payment confirmation failed: ' + confirmationResult.message
      });
    }

    // Create payment record
    const payment = await Payment.create({
      rentalId,
      userId: req.user.id,
      amount,
      currency: 'INR',
      paymentType,
      method: 'stripe',
      status: 'succeeded',
      provider: 'stripe',
      providerRef: paymentIntentId,
      transactionId: confirmationResult.data.transactionId
    });

    // Update rental status
    if (paymentType === 'full') {
      await Rental.findByIdAndUpdate(rentalId, { status: 'confirmed' });
    } else if (paymentType === 'deposit') {
      await Rental.findByIdAndUpdate(rentalId, { status: 'deposit_paid' });
    }

    // Generate invoice after successful payment
    let generatedInvoice = null;
    try {
      const rentalForInvoice = await Rental.findById(rentalId).populate('items.productId').populate('customerId');
      if (rentalForInvoice) {
        const invoiceData = {
          rentalId: rentalForInvoice._id,
          customerId: rentalForInvoice.customerId._id,
          customerDetails: {
            name: rentalForInvoice.customerSnapshot?.name || 'Unknown',
            email: rentalForInvoice.customerSnapshot?.email || 'unknown@example.com',
            phone: rentalForInvoice.customerSnapshot?.phone || '',
            address: rentalForInvoice.customerSnapshot?.address || '',
            city: rentalForInvoice.customerSnapshot?.city || '',
            zipCode: rentalForInvoice.customerSnapshot?.zipCode || ''
          },
          items: rentalForInvoice.items.map(item => ({
            productId: item.productId._id,
            productSnapshot: {
              name: item.productId.name,
              category: item.productId.category,
              pricePerHour: item.productId.pricePerHour,
              pricePerDay: item.productId.pricePerDay,
              pricePerWeek: item.productId.pricePerWeek
            },
            quantity: item.quantity,
            duration: item.duration,
            durationType: item.durationType,
            selectedAddOns: item.selectedAddOns || [],
            startDate: item.startDate,
            endDate: item.endDate,
            lineTotal: item.lineTotal
          })),
          pricing: {
            subtotal: rentalForInvoice.subtotal,
            serviceFee: rentalForInvoice.serviceFee,
            tax: rentalForInvoice.tax,
            total: rentalForInvoice.total,
            currency: 'INR'
          },
          paymentDetails: {
            paymentMode: rentalForInvoice.paymentMode,
            paymentStatus: 'paid',
            paymentMethod: 'stripe',
            transactionId: paymentIntentId,
            paidAmount: amount,
            paidAt: new Date()
          },
          status: 'paid',
          notes: 'Thank you for choosing FlexiRent!',
          terms: 'Payment is due within 7 days. Cancellation is free up to 24 hours before rental start date.'
        };
        generatedInvoice = await Invoice.create(invoiceData);
        console.log('Invoice generated for rental (Stripe):', rentalId, 'Invoice ID:', generatedInvoice._id);
      }
    } catch (invoiceError) {
      console.error('Error generating invoice:', invoiceError);
      // Continue with payment success even if invoice generation fails
    }

    res.json({
      success: true,
      message: 'Stripe payment confirmed successfully',
      data: {
        payment: {
          id: payment._id,
          amount: payment.amount,
          status: payment.status,
          providerRef: payment.providerRef
        },
        rental: {
          id: rental._id,
          status: paymentType === 'full' ? 'confirmed' : 'deposit_paid'
        },
        invoiceId: generatedInvoice ? generatedInvoice._id : null
      }
    });
  } catch (error) {
    console.error('Stripe payment confirmation error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while confirming payment'
    });
  }
};

// @desc    Process payment for a rental
// @route   POST /api/payments/process
// @access  Private
const processPayment = async (req, res) => {
  try {
    const { rentalId, paymentMethod, amount, paymentType } = req.body;

    if (!rentalId || !paymentMethod || !amount || !paymentType) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: rentalId, paymentMethod, amount, paymentType'
      });
    }

    // Find the rental
    const rental = await Rental.findById(rentalId);
    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Verify the rental belongs to the user
    if (rental.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. This rental does not belong to you.'
      });
    }

    // Simulate payment processing (in a real app, this would integrate with Stripe/PayPal)
    let paymentStatus = 'succeeded';
    let providerRef = `mock_${Date.now()}`;
    let errorReason = null;

    // Simulate payment failure for testing (5% chance)
    if (Math.random() < 0.05) {
      paymentStatus = 'failed';
      errorReason = 'Payment declined by bank';
    }

    // Create payment record
    const payment = await Payment.create({
      rentalId,
      userId: req.user.id,
      amount,
      currency: 'USD',
      paymentType,
      method: paymentMethod,
      status: paymentStatus,
      provider: 'mock_payment_gateway',
      providerRef,
      errorReason
    });

    if (paymentStatus === 'succeeded') {
      // Update rental status if full payment
      if (paymentType === 'full') {
        await Rental.findByIdAndUpdate(rentalId, { status: 'confirmed' });
      } else if (paymentType === 'deposit') {
        await Rental.findByIdAndUpdate(rentalId, { status: 'deposit_paid' });
      }

      // Generate invoice after successful payment
      let generatedInvoice = null;
      try {
        const rentalForInvoice = await Rental.findById(rentalId).populate('items.productId').populate('customerId');
        if (rentalForInvoice) {
          const invoiceData = {
            rentalId: rentalForInvoice._id,
            customerId: rentalForInvoice.customerId._id,
            customerDetails: {
              name: rentalForInvoice.customerSnapshot?.name || 'Unknown',
              email: rentalForInvoice.customerSnapshot?.email || 'unknown@example.com',
              phone: rentalForInvoice.customerSnapshot?.phone || '',
              address: rentalForInvoice.customerSnapshot?.address || '',
              city: rentalForInvoice.customerSnapshot?.city || '',
              zipCode: rentalForInvoice.customerSnapshot?.zipCode || ''
            },
            items: rentalForInvoice.items.map(item => ({
              productId: item.productId._id,
              productSnapshot: {
                name: item.productId.name,
                category: item.productId.category,
                pricePerHour: item.productId.pricePerHour,
                pricePerDay: item.productId.pricePerDay,
                pricePerWeek: item.productId.pricePerWeek
              },
              quantity: item.quantity,
              duration: item.duration,
              durationType: item.durationType,
              selectedAddOns: item.selectedAddOns || [],
              startDate: item.startDate,
              endDate: item.endDate,
              lineTotal: item.lineTotal
            })),
            pricing: {
              subtotal: rentalForInvoice.subtotal,
              serviceFee: rentalForInvoice.serviceFee,
              tax: rentalForInvoice.tax,
              total: rentalForInvoice.total,
              currency: 'INR'
            },
            paymentDetails: {
              paymentMode: rentalForInvoice.paymentMode,
              paymentStatus: 'paid',
              paymentMethod: paymentMethod,
              transactionId: providerRef,
              paidAmount: amount,
              paidAt: new Date()
            },
            status: 'paid',
            notes: 'Thank you for choosing FlexiRent!',
            terms: 'Payment is due within 7 days. Cancellation is free up to 24 hours before rental start date.'
          };
          generatedInvoice = await Invoice.create(invoiceData);
          console.log('Invoice generated for rental:', rentalId, 'Invoice ID:', generatedInvoice._id);
        }
      } catch (invoiceError) {
        console.error('Error generating invoice:', invoiceError);
        // Continue with payment success even if invoice generation fails
      }

      res.json({
        success: true,
        message: 'Payment processed successfully',
        data: {
          payment: {
            id: payment._id,
            amount: payment.amount,
            status: payment.status,
            providerRef: payment.providerRef
          },
          rental: {
            id: rental._id,
            status: paymentType === 'full' ? 'confirmed' : 'deposit_paid'
          },
          invoiceId: generatedInvoice ? generatedInvoice._id : null
        }
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Payment failed',
        data: {
          payment: {
            id: payment._id,
            status: payment.status,
            errorReason: payment.errorReason
          }
        }
      });
    }
  } catch (error) {
    console.error('Payment processing error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while processing payment'
    });
  }
};

// @desc    Initiate Paytm payment
// @route   POST /api/payments/paytm/initiate
// @access  Private
const initiatePaytmPayment = async (req, res) => {
  try {
    const { rentalId, paymentMethod, amount, paymentType, customerPhone } = req.body;

    if (!rentalId || !amount || !paymentType) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: rentalId, amount, paymentType'
      });
    }

    // Find the rental
    const rental = await Rental.findById(rentalId);
    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Verify the rental belongs to the user
    if (rental.userId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. This rental does not belong to you.'
      });
    }

    // Generate unique order ID
    const orderId = paytmService.generateOrderId();
    
    // Initialize Paytm payment
    const paymentData = {
      orderId,
      customerId: req.user.id,
      amount: amount.toString(),
      customerName: req.user.name,
      customerEmail: req.user.email,
      customerPhone: customerPhone || '9999999999',
      callbackUrl: `${req.protocol}://${req.get('host')}/api/payments/paytm/callback`
    };

    const paytmResponse = await paytmService.initializePayment(paymentData);
    
    if (paytmResponse.success) {
      // Create pending payment record
      const payment = await Payment.create({
        rentalId,
        userId: req.user.id,
        amount,
        currency: 'INR',
        paymentType,
        method: 'paytm',
        status: 'pending',
        provider: 'paytm',
        providerRef: orderId
      });

      res.json({
        success: true,
        message: 'Paytm payment initiated successfully',
        data: {
          payment: {
            id: payment._id,
            orderId: orderId,
            amount: payment.amount,
            status: payment.status
          },
          paytmParams: paytmResponse.data.paytmParams,
          redirectUrl: paytmResponse.data.redirectUrl
        }
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Failed to initiate Paytm payment',
        error: paytmResponse.message
      });
    }
  } catch (error) {
    console.error('Paytm initiation error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while initiating Paytm payment'
    });
  }
};

// @desc    Paytm payment callback
// @route   POST /api/payments/paytm/callback
// @access  Public
const paytmCallback = async (req, res) => {
  try {
    const paytmResponse = req.body;
    
    // Verify checksum
    const isValidChecksum = paytmService.verifyChecksum(
      paytmResponse, 
      paytmResponse.CHECKSUMHASH, 
      process.env.PAYTM_MERCHANT_KEY || 'YOUR_MERCHANT_KEY'
    );

    if (!isValidChecksum) {
      console.error('Invalid checksum in Paytm callback');
      return res.status(400).json({
        success: false,
        message: 'Invalid checksum'
      });
    }

    const { ORDERID, TXNID, TXNAMOUNT, STATUS, RESPCODE, RESPMSG } = paytmResponse;
    
    // Find payment by order ID
    const payment = await Payment.findOne({ providerRef: ORDERID });
    if (!payment) {
      console.error('Payment not found for order:', ORDERID);
      return res.status(404).json({
        success: false,
        message: 'Payment not found'
      });
    }

    if (STATUS === 'TXN_SUCCESS') {
      // Update payment status
      payment.status = 'succeeded';
      payment.providerRef = TXNID;
      await payment.save();

      // Update rental status
      if (payment.paymentType === 'full') {
        await Rental.findByIdAndUpdate(payment.rentalId, { status: 'confirmed' });
      } else if (payment.paymentType === 'deposit') {
        await Rental.findByIdAndUpdate(payment.rentalId, { status: 'deposit_paid' });
      }

      // Generate invoice after successful Paytm payment
      let generatedInvoice = null;
      try {
        const rentalForInvoice = await Rental.findById(payment.rentalId).populate('items.productId').populate('customerId');
        if (rentalForInvoice) {
          const invoiceData = {
            rentalId: rentalForInvoice._id,
            customerId: rentalForInvoice.customerId._id,
            customerDetails: {
              name: rentalForInvoice.customerSnapshot?.name || 'Unknown',
              email: rentalForInvoice.customerSnapshot?.email || 'unknown@example.com',
              phone: rentalForInvoice.customerSnapshot?.phone || '',
              address: rentalForInvoice.customerSnapshot?.address || '',
              city: rentalForInvoice.customerSnapshot?.city || '',
              zipCode: rentalForInvoice.customerSnapshot?.zipCode || ''
            },
            items: rentalForInvoice.items.map(item => ({
              productId: item.productId._id,
              productSnapshot: {
                name: item.productId.name,
                category: item.productId.category,
                pricePerHour: item.productId.pricePerHour,
                pricePerDay: item.productId.pricePerDay,
                pricePerWeek: item.productId.pricePerWeek
              },
              quantity: item.quantity,
              duration: item.duration,
              durationType: item.durationType,
              selectedAddOns: item.selectedAddOns || [],
              startDate: item.startDate,
              endDate: item.endDate,
              lineTotal: item.lineTotal
            })),
            pricing: {
              subtotal: rentalForInvoice.subtotal,
              serviceFee: rentalForInvoice.serviceFee,
              tax: rentalForInvoice.tax,
              total: rentalForInvoice.total,
              currency: 'INR'
            },
            paymentDetails: {
              paymentMode: rentalForInvoice.paymentMode,
              paymentStatus: 'paid',
              paymentMethod: 'paytm',
              transactionId: TXNID,
              paidAmount: parseFloat(TXNAMOUNT),
              paidAt: new Date()
            },
            status: 'paid',
            notes: 'Thank you for choosing FlexiRent!',
            terms: 'Payment is due within 7 days. Cancellation is free up to 24 hours before rental start date.'
          };
          generatedInvoice = await Invoice.create(invoiceData);
          console.log('Invoice generated for rental (Paytm callback):', payment.rentalId, 'Invoice ID:', generatedInvoice._id);
          
          // Redirect to invoice page
          return res.redirect(`${process.env.FRONTEND_URL || 'http://localhost:5173'}/invoice-${generatedInvoice._id}`);
        }
      } catch (invoiceError) {
        console.error('Error generating invoice in Paytm callback:', invoiceError);
        // Fallback to success page if invoice generation fails
        return res.redirect(`${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment-success?orderId=${ORDERID}&status=success`);
      }

      // Fallback redirect if no invoice was generated
      res.redirect(`${process.env.FRONTEND_URL || 'http://localhost:5173'}/payment-success?orderId=${ORDERID}&status=success`);
    } else {
      // Payment failed
      payment.status = 'failed';
      payment.errorReason = RESPMSG;
      await payment.save();

      // Redirect to failure page
      res.redirect(`/payment-failed?orderId=${ORDERID}&status=failed&message=${RESPMSG}`);
    }
  } catch (error) {
    console.error('Paytm callback error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error in Paytm callback'
    });
  }
};

// @desc    Verify Paytm payment
// @route   POST /api/payments/paytm/verify
// @access  Private
const verifyPaytmPayment = async (req, res) => {
  try {
    const { orderId } = req.body;

    if (!orderId) {
      return res.status(400).json({
        success: false,
        message: 'Order ID is required'
      });
    }

    // Verify payment with Paytm
    const verificationResult = await paytmService.verifyPayment(orderId);
    
    if (verificationResult.success) {
      // Find and update payment
      const payment = await Payment.findOne({ providerRef: orderId });
      if (payment) {
        payment.status = 'succeeded';
        payment.providerRef = verificationResult.data.transactionId;
        await payment.save();

        // Update rental status
        if (payment.paymentType === 'full') {
          await Rental.findByIdAndUpdate(payment.rentalId, { status: 'confirmed' });
        } else if (payment.paymentType === 'deposit') {
          await Rental.findByIdAndUpdate(payment.rentalId, { status: 'deposit_paid' });
        }
      }

      res.json({
        success: true,
        message: 'Payment verified successfully',
        data: verificationResult.data
      });
    } else {
      res.json({
        success: false,
        message: 'Payment verification failed',
        data: verificationResult.data
      });
    }
  } catch (error) {
    console.error('Paytm verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while verifying payment'
    });
  }
};

// @desc    Get payment history for a user
// @route   GET /api/payments/history
// @access  Private
const getPaymentHistory = async (req, res) => {
  try {
    const payments = await Payment.find({ userId: req.user.id })
      .populate('rentalId', 'items total status')
      .sort({ createdAt: -1 });

    res.json({
      success: true,
      data: { payments }
    });
  } catch (error) {
    console.error('Get payment history error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching payment history'
    });
  }
};

// @desc    Get payment details
// @route   GET /api/payments/:id
// @access  Private
const getPaymentDetails = async (req, res) => {
  try {
    const payment = await Payment.findById(req.params.id)
      .populate('rentalId', 'items total status')
      .populate('userId', 'name email');

    if (!payment) {
      return res.status(404).json({
        success: false,
        message: 'Payment not found'
      });
    }

    // Verify access
    if (payment.userId._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    res.json({
      success: true,
      data: { payment }
    });
  } catch (error) {
    console.error('Get payment details error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching payment details'
    });
  }
};

// @desc    Refund payment (admin only)
// @route   POST /api/payments/:id/refund
// @access  Private (Admin only)
const refundPayment = async (req, res) => {
  try {
    const payment = await Payment.findById(req.params.id);
    
    if (!payment) {
      return res.status(404).json({
        success: false,
        message: 'Payment not found'
      });
    }

    if (payment.status !== 'succeeded') {
      return res.status(400).json({
        success: false,
        message: 'Only successful payments can be refunded'
      });
    }

    // Update payment status
    payment.status = 'refunded';
    await payment.save();

    // Update rental status if needed
    await Rental.findByIdAndUpdate(payment.rentalId, { status: 'cancelled' });

    res.json({
      success: true,
      message: 'Payment processed successfully',
      data: { payment }
    });
  } catch (error) {
    console.error('Refund payment error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while processing refund'
    });
  }
};

// Stripe payment routes
router.post('/stripe/create-payment-intent', protect, createStripePaymentIntent);
router.post('/stripe/confirm-payment', protect, confirmStripePayment);

// Paytm payment routes
router.post('/paytm/initiate', protect, initiatePaytmPayment);
router.post('/paytm/callback', paytmCallback);
router.post('/paytm/verify', protect, verifyPaytmPayment);

// Regular payment routes
router.post('/process', protect, processPayment);
router.get('/history', protect, getPaymentHistory);
router.get('/:id', protect, getPaymentDetails);
router.post('/:id/refund', protect, authorize('admin'), refundPayment);

module.exports = router;
