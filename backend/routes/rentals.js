const express = require('express');
const Rental = require('../models/Rental');
const Product = require('../models/Product');
const ProductBooking = require('../models/ProductBooking');
const { protect, authorize } = require('../middleware/auth');
const router = express.Router();

// Helper function to calculate pricing
const calculatePricing = (items) => {
  let subtotal = 0;
  
  items.forEach(item => {
    const basePrice = item.durationType === 'hour' 
      ? item.unitBasePrice 
      : item.durationType === 'day' 
      ? item.unitBasePrice 
      : item.unitBasePrice;
    
    const lineTotal = (basePrice * item.quantity * item.duration) + item.addOnTotal;
    item.lineTotal = lineTotal;
    subtotal += lineTotal;
  });
  
  const serviceFee = Math.round(subtotal * 0.05); // 5% service fee
  const tax = Math.round(subtotal * 0.08); // 8% tax
  const total = subtotal + serviceFee + tax;
  
  return { subtotal, serviceFee, tax, total };
};

// @desc    Create a new rental/booking
// @route   POST /api/rentals
// @access  Private
const createRental = async (req, res) => {
  try {
    const {
      items,
      paymentMode,
      delivery,
      customerSnapshot
    } = req.body;

    // Validate required fields
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'At least one item is required'
      });
    }

    // Validate and process each item
    const processedItems = [];
    for (const item of items) {
      // Get product details
      const product = await Product.findById(item.productId);
      if (!product) {
        return res.status(400).json({
          success: false,
          message: `Product with ID ${item.productId} not found`
        });
      }

      // Check if product is available
      if (product.availability !== 'available') {
        return res.status(400).json({
          success: false,
          message: `Product ${product.name} is not available for booking`
        });
      }

      // Calculate base price based on duration type
      let unitBasePrice;
      switch (item.durationType) {
        case 'hour':
          unitBasePrice = product.pricePerHour;
          break;
        case 'day':
          unitBasePrice = product.pricePerDay;
          break;
        case 'week':
          unitBasePrice = product.pricePerWeek;
          break;
        default:
          return res.status(400).json({
            success: false,
            message: 'Invalid duration type'
          });
      }

      // Calculate add-on total
      const addOnTotal = (item.selectedAddOns || []).reduce((sum, addOn) => sum + addOn.price, 0);

      // Create product snapshot
      const productSnapshot = {
        name: product.name,
        pricePerHour: product.pricePerHour,
        pricePerDay: product.pricePerDay,
        pricePerWeek: product.pricePerWeek,
      };

      processedItems.push({
        productId: item.productId,
        productSnapshot,
        quantity: item.quantity,
        duration: item.duration,
        durationType: item.durationType,
        selectedAddOns: item.selectedAddOns || [],
        startDate: new Date(item.startDate),
        endDate: new Date(item.endDate),
        unitBasePrice,
        addOnTotal,
        lineTotal: 0 // Will be calculated below
      });
    }

    // Calculate pricing
    const { subtotal, serviceFee, tax, total } = calculatePricing(processedItems);

    // Calculate deposit and balance
    const depositAmount = paymentMode === 'deposit' ? Math.round(total * 0.3) : 0; // 30% deposit
    const balanceDue = total - depositAmount;

    // Create rental
    const rentalData = {
      userId: req.user.id,
      items: processedItems,
      paymentMode,
      subtotal,
      serviceFee,
      tax,
      total,
      depositAmount,
      balanceDue,
      status: 'upcoming',
      delivery: delivery || { method: 'pickup' },
      customerSnapshot: customerSnapshot || {
        name: req.user.name,
        email: req.user.email,
        phone: ''
      }
    };

    const rental = await Rental.create(rentalData);

    // Create product bookings for each item
    const productBookings = [];
    for (const item of processedItems) {
      const booking = await ProductBooking.create({
        productId: item.productId,
        rentalId: rental._id,
        status: 'confirmed',
        startDate: item.startDate,
        endDate: item.endDate,
        quantity: item.quantity
      });
      productBookings.push(booking);
    }

    // Update product availability
    for (const item of processedItems) {
      await Product.findByIdAndUpdate(item.productId, {
        availability: 'booked'
      });
    }

    // Populate the rental with user details
    const populatedRental = await Rental.findById(rental._id)
      .populate('userId', 'name email')
      .populate('items.productId', 'name image category');

    res.status(201).json({
      success: true,
      message: 'Rental created successfully',
      data: { 
        rental: populatedRental,
        productBookings 
      }
    });
  } catch (error) {
    console.error('Create rental error:', error);
    
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map(err => err.message);
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors: messages
      });
    }

    res.status(500).json({
      success: false,
      message: 'Server error while creating rental'
    });
  }
};

// @desc    Get user's rentals
// @route   GET /api/rentals/my-rentals
// @access  Private
const getMyRentals = async (req, res) => {
  try {
    const { 
      status, 
      page = 1, 
      limit = 10,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // Build filter object
    const filter = { userId: req.user.id };
    
    if (status) {
      filter.status = status;
    }

    // Build sort object
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // Calculate pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);

    const rentals = await Rental.find(filter)
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit))
      .populate('items.productId', 'name image category')
      .populate('userId', 'name email');

    const total = await Rental.countDocuments(filter);

    res.json({
      success: true,
      data: {
        rentals,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      }
    });
  } catch (error) {
    console.error('Get my rentals error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching rentals'
    });
  }
};

// @desc    Get all rentals (admin only)
// @route   GET /api/rentals
// @access  Private (Admin only)
const getAllRentals = async (req, res) => {
  try {
    const { 
      status, 
      userId,
      page = 1, 
      limit = 10,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // Build filter object
    const filter = {};
    
    if (status) {
      filter.status = status;
    }
    
    if (userId) {
      filter.userId = userId;
    }

    // Build sort object
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // Calculate pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);

    const rentals = await Rental.find(filter)
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit))
      .populate('items.productId', 'name image category')
      .populate('userId', 'name email');

    const total = await Rental.countDocuments(filter);

    res.json({
      success: true,
      data: {
        rentals,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      }
    });
  } catch (error) {
    console.error('Get all rentals error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching rentals'
    });
  }
};

// @desc    Get single rental
// @route   GET /api/rentals/:id
// @access  Private
const getRental = async (req, res) => {
  try {
    const rental = await Rental.findById(req.params.id)
      .populate('items.productId', 'name image category description')
      .populate('userId', 'name email');

    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Check if user is authorized to view this rental
    if (rental.userId._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to view this rental'
      });
    }

    res.json({
      success: true,
      data: { rental }
    });
  } catch (error) {
    console.error('Get rental error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching rental'
    });
  }
};

// @desc    Update rental status
// @route   PATCH /api/rentals/:id/status
// @access  Private (Admin only)
const updateRentalStatus = async (req, res) => {
  try {
    const { status } = req.body;

    if (!['upcoming', 'active', 'completed', 'cancelled'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status'
      });
    }

    const rental = await Rental.findById(req.params.id);

    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    rental.status = status;
    await rental.save();

    // Update product bookings status
    if (status === 'cancelled') {
      await ProductBooking.updateMany(
        { rentalId: rental._id },
        { status: 'cancelled' }
      );

      // Update product availability back to available
      for (const item of rental.items) {
        await Product.findByIdAndUpdate(item.productId, {
          availability: 'available'
        });
      }
    } else if (status === 'completed') {
      await ProductBooking.updateMany(
        { rentalId: rental._id },
        { status: 'returned' }
      );

      // Update product availability back to available
      for (const item of rental.items) {
        await Product.findByIdAndUpdate(item.productId, {
          availability: 'available'
        });
      }
    }

    const updatedRental = await Rental.findById(rental._id)
      .populate('items.productId', 'name image category')
      .populate('userId', 'name email');

    res.json({
      success: true,
      message: 'Rental status updated successfully',
      data: { rental: updatedRental }
    });
  } catch (error) {
    console.error('Update rental status error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while updating rental status'
    });
  }
};

// @desc    Cancel rental (user can cancel upcoming rentals)
// @route   PATCH /api/rentals/:id/cancel
// @access  Private
const cancelRental = async (req, res) => {
  try {
    const rental = await Rental.findById(req.params.id);

    if (!rental) {
      return res.status(404).json({
        success: false,
        message: 'Rental not found'
      });
    }

    // Check if user is authorized to cancel this rental
    if (rental.userId.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to cancel this rental'
      });
    }

    // Only allow cancellation of upcoming rentals
    if (rental.status !== 'upcoming') {
      return res.status(400).json({
        success: false,
        message: 'Only upcoming rentals can be cancelled'
      });
    }

    rental.status = 'cancelled';
    await rental.save();

    // Update product bookings status
    await ProductBooking.updateMany(
      { rentalId: rental._id },
      { status: 'cancelled' }
    );

    // Update product availability back to available
    for (const item of rental.items) {
      await Product.findByIdAndUpdate(item.productId, {
        availability: 'available'
      });
    }

    const updatedRental = await Rental.findById(rental._id)
      .populate('items.productId', 'name image category')
      .populate('userId', 'name email');

    res.json({
      success: true,
      message: 'Rental cancelled successfully',
      data: { rental: updatedRental }
    });
  } catch (error) {
    console.error('Cancel rental error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while cancelling rental'
    });
  }
};

// @desc    Get rental statistics
// @route   GET /api/rentals/stats
// @access  Private (Admin only)
const getRentalStats = async (req, res) => {
  try {
    const totalRentals = await Rental.countDocuments();
    const totalRevenue = await Rental.aggregate([
      { $group: { _id: null, total: { $sum: '$total' } } }
    ]);
    
    const activeRentals = await Rental.countDocuments({ 
      status: { $in: ['upcoming', 'active'] } 
    });
    
    const monthlyRevenue = await Rental.aggregate([
      {
        $match: {
          createdAt: { $gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) }
        }
      },
      { $group: { _id: null, total: { $sum: '$total' } } }
    ]);

    const statusBreakdown = await Rental.aggregate([
      { $group: { _id: '$status', count: { $sum: 1 } } }
    ]);

    res.json({
      success: true,
      data: {
        totalRentals,
        totalRevenue: totalRevenue[0]?.total || 0,
        activeRentals,
        monthlyRevenue: monthlyRevenue[0]?.total || 0,
        statusBreakdown
      }
    });
  } catch (error) {
    console.error('Get rental stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching rental statistics'
    });
  }
};

// Routes
router.post('/', protect, createRental);
router.get('/my-rentals', protect, getMyRentals);
router.get('/stats', protect, authorize('admin'), getRentalStats);
router.get('/:id', protect, getRental);
router.patch('/:id/status', protect, authorize('admin'), updateRentalStatus);
router.patch('/:id/cancel', protect, cancelRental);

// Admin routes
router.get('/', protect, authorize('admin'), getAllRentals);

module.exports = router;
