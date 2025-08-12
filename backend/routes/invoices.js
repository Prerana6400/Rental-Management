const express = require('express');
const Invoice = require('../models/Invoice');
const Rental = require('../models/Rental');
const { protect, authorize } = require('../middleware/auth');
const router = express.Router();

// @desc    Generate invoice for a rental
// @route   POST /api/invoices/generate
// @access  Private
const generateInvoice = async (req, res) => {
  try {
    const { rentalId, customerDetails } = req.body;

    if (!rentalId) {
      return res.status(400).json({
        success: false,
        message: 'Rental ID is required'
      });
    }

    // Find the rental
    const rental = await Rental.findById(rentalId)
      .populate('items.productId')
      .populate('customerId');

    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Check if invoice already exists
    const existingInvoice = await Invoice.findOne({ rentalId });
    if (existingInvoice) {
      return res.status(400).json({
        success: false,
        message: 'Invoice already exists for this rental'
      });
    }

    // Transform rental items to invoice items
    const invoiceItems = rental.items.map(item => ({
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
    }));

    // Create invoice data
    const invoiceData = {
      rentalId: rental._id,
      customerId: rental.customerId._id,
      customerDetails: {
        name: customerDetails?.name || rental.customerId.name,
        email: customerDetails?.email || rental.customerId.email,
        phone: customerDetails?.phone || '',
        address: customerDetails?.address || '',
        city: customerDetails?.city || '',
        zipCode: customerDetails?.zipCode || ''
      },
      items: invoiceItems,
      pricing: {
        subtotal: rental.subtotal,
        serviceFee: rental.serviceFee,
        tax: rental.tax,
        total: rental.total,
        currency: 'INR'
      },
      paymentDetails: {
        paymentMode: rental.paymentMode,
        paymentMethod: 'paytm',
        paymentStatus: 'pending'
      },
      status: 'draft',
      notes: 'Thank you for choosing FlexiRent!',
      terms: 'Payment is due within 7 days. Cancellation is free up to 24 hours before rental start date.'
    };

    const invoice = await Invoice.create(invoiceData);

    res.status(201).json({
      success: true,
      message: 'Invoice generated successfully',
      data: { invoice }
    });
  } catch (error) {
    console.error('Generate invoice error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while generating invoice'
    });
  }
};

// @desc    Get invoice by ID
// @route   GET /api/invoices/:id
// @access  Private
const getInvoiceById = async (req, res) => {
  try {
    const invoice = await Invoice.findById(req.params.id)
      .populate('rentalId')
      .populate('customerId')
      .populate('items.productId');

    if (!invoice) {
      return res.status(404).json({
        success: false,
        message: 'Invoice not found'
      });
    }

    // Check if user has access to this invoice
    if (req.user.role !== 'admin' && invoice.customerId.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. You can only view your own invoices.'
      });
    }

    res.json({
      success: true,
      data: { invoice }
    });
  } catch (error) {
    console.error('Get invoice error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching invoice'
    });
  }
};

// @desc    Get all invoices for a user
// @route   GET /api/invoices/user/:userId
// @access  Private (admin or own invoices)
const getUserInvoices = async (req, res) => {
  try {
    const { userId } = req.params;
    const { page = 1, limit = 10, status } = req.query;

    // Check if user has access
    if (req.user.role !== 'admin' && req.user.id !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Access denied'
      });
    }

    const query = { customerId: userId };
    if (status) query.status = status;

    const skip = (parseInt(page) - 1) * parseInt(limit);

    const invoices = await Invoice.find(query)
      .populate('rentalId', 'status total')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Invoice.countDocuments(query);

    res.json({
      success: true,
      data: {
        invoices,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      }
    });
  } catch (error) {
    console.error('Get user invoices error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching invoices'
    });
  }
};

// @desc    Get all invoices (admin only)
// @route   GET /api/invoices
// @access  Private (admin only)
const getAllInvoices = async (req, res) => {
  try {
    const { page = 1, limit = 10, status, customerId } = req.query;

    const query = {};
    if (status) query.status = status;
    if (customerId) query.customerId = customerId;

    const skip = (parseInt(page) - 1) * parseInt(limit);

    const invoices = await Invoice.find(query)
      .populate('customerId', 'name email')
      .populate('rentalId', 'status total')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Invoice.countDocuments(query);

    res.json({
      success: true,
      data: {
        invoices,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      }
    });
  } catch (error) {
    console.error('Get all invoices error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching invoices'
    });
  }
};

// @desc    Update invoice status
// @route   PUT /api/invoices/:id/status
// @access  Private (admin only)
const updateInvoiceStatus = async (req, res) => {
  try {
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'Status is required'
      });
    }

    const invoice = await Invoice.findById(req.params.id);
    if (!invoice) {
      return res.status(404).json({
        success: false,
        message: 'Invoice not found'
      });
    }

    invoice.status = status;
    if (status === 'paid') {
      invoice.paymentDetails.paymentStatus = 'paid';
      invoice.paidAt = new Date();
    }

    await invoice.save();

    res.json({
      success: true,
      message: 'Invoice status updated successfully',
      data: { invoice }
    });
  } catch (error) {
    console.error('Update invoice status error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while updating invoice status'
    });
  }
};

// @desc    Mark invoice as paid
// @route   PUT /api/invoices/:id/mark-paid
// @access  Private (admin only)
const markInvoiceAsPaid = async (req, res) => {
  try {
    const { transactionId, paidAmount } = req.body;

    const invoice = await Invoice.findById(req.params.id);
    if (!invoice) {
      return res.status(404).json({
        success: false,
        message: 'Invoice not found'
      });
    }

    invoice.status = 'paid';
    invoice.paymentDetails.paymentStatus = 'paid';
    invoice.paymentDetails.transactionId = transactionId;
    invoice.paymentDetails.paidAmount = paidAmount;
    invoice.paidAt = new Date();

    await invoice.save();

    res.json({
      success: true,
      message: 'Invoice marked as paid successfully',
      data: { invoice }
    });
  } catch (error) {
    console.error('Mark invoice as paid error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while marking invoice as paid'
    });
  }
};

// @desc    Delete invoice
// @route   DELETE /api/invoices/:id
// @access  Private (admin only)
const deleteInvoice = async (req, res) => {
  try {
    const invoice = await Invoice.findById(req.params.id);
    if (!invoice) {
      return res.status(404).json({
        success: false,
        message: 'Invoice not found'
      });
    }

    await Invoice.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: 'Invoice deleted successfully'
    });
  } catch (error) {
    console.error('Delete invoice error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while deleting invoice'
    });
  }
};

// Routes
router.post('/generate', protect, generateInvoice);
router.get('/:id', protect, getInvoiceById);
router.get('/user/:userId', protect, getUserInvoices);
router.get('/', protect, authorize('admin'), getAllInvoices);
router.put('/:id/status', protect, authorize('admin'), updateInvoiceStatus);
router.put('/:id/mark-paid', protect, authorize('admin'), markInvoiceAsPaid);
router.delete('/:id', protect, authorize('admin'), deleteInvoice);

module.exports = router;
