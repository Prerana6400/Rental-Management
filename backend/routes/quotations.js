const express = require('express');
const Quotation = require('../models/Quotation');
const User = require('../models/User');
const Product = require('../models/Product');
const { protect, authorize } = require('../middleware/auth');
const router = express.Router();

// Get all quotations (admin only)
const getAllQuotations = async (req, res) => {
  try {
    const { page = 1, limit = 10, status, customerId, sortBy = 'createdAt', sortOrder = 'desc' } = req.query;
    
    const query = {};
    if (status) query.status = status;
    if (customerId) query.userId = customerId;
    
    const sortOptions = {};
    sortOptions[sortBy] = sortOrder === 'desc' ? -1 : 1;
    
    const quotations = await Quotation.find(query)
      .populate('userId', 'name email phone')
      .populate('items.productId', 'name image category')
      .sort(sortOptions)
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .exec();
    
    const total = await Quotation.countDocuments(query);
    
    res.json({
      success: true,
      data: {
        quotations,
        pagination: {
          currentPage: page,
          totalPages: Math.ceil(total / limit),
          totalQuotations: total,
          hasNext: page * limit < total,
          hasPrev: page > 1
        }
      }
    });
  } catch (error) {
    console.error('Error fetching quotations:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch quotations' });
  }
};

// Get quotation by ID (admin only)
const getQuotationById = async (req, res) => {
  try {
    const quotation = await Quotation.findById(req.params.id)
      .populate('userId', 'name email phone address')
      .populate('items.productId', 'name image category description pricePerHour pricePerDay pricePerWeek features addOns');
    
    if (!quotation) {
      return res.status(404).json({ success: false, message: 'Quotation not found' });
    }
    
    res.json({ success: true, data: quotation });
  } catch (error) {
    console.error('Error fetching quotation:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch quotation' });
  }
};

// Create quotation (admin only)
const createQuotation = async (req, res) => {
  try {
    const { userId, items, validUntil } = req.body;
    
    // Validate user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(400).json({ success: false, message: 'User not found' });
    }
    
    // Calculate totals
    let subtotal = 0;
    const processedItems = [];
    
    for (const item of items) {
      const product = await Product.findById(item.productId);
      if (!product) {
        return res.status(400).json({ success: false, message: `Product ${item.productId} not found` });
      }
      
      // Calculate base price based on duration type
      let basePrice = 0;
      switch (item.durationType) {
        case 'hour':
          basePrice = product.pricePerHour;
          break;
        case 'day':
          basePrice = product.pricePerDay;
          break;
        case 'week':
          basePrice = product.pricePerWeek;
          break;
        default:
          return res.status(400).json({ success: false, message: 'Invalid duration type' });
      }
      
      const unitBasePrice = basePrice;
      const addOnTotal = item.selectedAddOns.reduce((sum, addon) => sum + addon.price, 0);
      const lineTotal = (unitBasePrice * item.quantity * item.duration) + addOnTotal;
      
      subtotal += lineTotal;
      
      processedItems.push({
        ...item,
        productSnapshot: {
          name: product.name,
          pricePerHour: product.pricePerHour,
          pricePerDay: product.pricePerDay,
          pricePerWeek: product.pricePerWeek
        },
        unitBasePrice,
        addOnTotal,
        lineTotal
      });
    }
    
    const serviceFee = Math.round(subtotal * 0.05); // 5% service fee
    const tax = Math.round(subtotal * 0.18); // 18% GST
    const total = subtotal + serviceFee + tax;
    
    const quotation = new Quotation({
      userId,
      items: processedItems,
      subtotal,
      serviceFee,
      tax,
      total,
      validUntil: new Date(validUntil || Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days default
    });
    
    await quotation.save();
    
    const populatedQuotation = await Quotation.findById(quotation._id)
      .populate('userId', 'name email phone')
      .populate('items.productId', 'name image category');
    
    res.status(201).json({ success: true, data: populatedQuotation });
  } catch (error) {
    console.error('Error creating quotation:', error);
    res.status(500).json({ success: false, message: 'Failed to create quotation' });
  }
};

// Update quotation status (admin only)
const updateQuotationStatus = async (req, res) => {
  try {
    const { status, notes } = req.body;
    const { id } = req.params;
    
    const quotation = await Quotation.findById(id);
    if (!quotation) {
      return res.status(404).json({ success: false, message: 'Quotation not found' });
    }
    
    // Validate status transition
    const validTransitions = {
      pending: ['accepted', 'rejected', 'expired'],
      accepted: ['expired'],
      rejected: ['expired'],
      expired: []
    };
    
    if (!validTransitions[quotation.status].includes(status)) {
      return res.status(400).json({ 
        success: false, 
        message: `Cannot change status from ${quotation.status} to ${status}` 
      });
    }
    
    quotation.status = status;
    if (notes) {
      quotation.notes = notes;
    }
    
    await quotation.save();
    
    res.json({ success: true, data: quotation });
  } catch (error) {
    console.error('Error updating quotation status:', error);
    res.status(500).json({ success: false, message: 'Failed to update quotation status' });
  }
};

// Delete quotation (admin only)
const deleteQuotation = async (req, res) => {
  try {
    const quotation = await Quotation.findById(req.params.id);
    if (!quotation) {
      return res.status(404).json({ success: false, message: 'Quotation not found' });
    }
    
    // Only allow deletion of pending or expired quotations
    if (quotation.status === 'accepted' || quotation.status === 'rejected') {
      return res.status(400).json({ 
        success: false, 
        message: 'Cannot delete accepted or rejected quotations' 
      });
    }
    
    await Quotation.findByIdAndDelete(req.params.id);
    
    res.json({ success: true, message: 'Quotation deleted successfully' });
  } catch (error) {
    console.error('Error deleting quotation:', error);
    res.status(500).json({ success: false, message: 'Failed to delete quotation' });
  }
};

// Get quotation statistics (admin only)
const getQuotationStats = async (req, res) => {
  try {
    const stats = await Quotation.aggregate([
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 },
          totalValue: { $sum: '$total' }
        }
      }
    ]);
    
    const totalQuotations = await Quotation.countDocuments();
    const totalValue = await Quotation.aggregate([
      { $group: { _id: null, total: { $sum: '$total' } } }
    ]);
    
    const monthlyStats = await Quotation.aggregate([
      {
        $match: {
          createdAt: { $gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1) }
        }
      },
      {
        $group: {
          _id: { $dateToString: { format: "%Y-%m", date: "$createdAt" } },
          count: { $sum: 1 },
          totalValue: { $sum: '$total' }
        }
      },
      { $sort: { _id: -1 } }
    ]);
    
    res.json({
      success: true,
      data: {
        totalQuotations,
        totalValue: totalValue[0]?.total || 0,
        statusBreakdown: stats,
        monthlyStats
      }
    });
  } catch (error) {
    console.error('Error fetching quotation stats:', error);
    res.status(500).json({ success: false, message: 'Failed to fetch quotation statistics' });
  }
};

// Convert quotation to rental (admin only)
const convertToRental = async (req, res) => {
  try {
    const quotation = await Quotation.findById(req.params.id)
      .populate('userId', 'name email phone address');
    
    if (!quotation) {
      return res.status(404).json({ success: false, message: 'Quotation not found' });
    }
    
    if (quotation.status !== 'accepted') {
      return res.status(400).json({ 
        success: false, 
        message: 'Only accepted quotations can be converted to rentals' 
      });
    }
    
    // Check if quotation is still valid
    if (new Date() > quotation.validUntil) {
      return res.status(400).json({ 
        success: false, 
        message: 'Quotation has expired' 
      });
    }
    
    // Create rental from quotation
    const Rental = require('../models/Rental');
    const rental = new Rental({
      userId: quotation.userId._id,
      items: quotation.items.map(item => ({
        productId: item.productId,
        quantity: item.quantity,
        duration: item.duration,
        durationType: item.durationType,
        selectedAddOns: item.selectedAddOns,
        startDate: item.startDate,
        endDate: item.endDate,
        unitBasePrice: item.unitBasePrice,
        addOnTotal: item.addOnTotal,
        lineTotal: item.lineTotal
      })),
      subtotal: quotation.subtotal,
      serviceFee: quotation.serviceFee,
      tax: quotation.tax,
      total: quotation.total,
      status: 'upcoming',
      customerId: quotation.userId._id,
      customerName: quotation.userId.name,
      customerEmail: quotation.userId.email
    });
    
    await rental.save();
    
    // Update quotation with rental reference
    quotation.convertedRentalId = rental._id;
    quotation.status = 'expired'; // Mark as expired since it's now a rental
    await quotation.save();
    
    res.json({ 
      success: true, 
      message: 'Quotation converted to rental successfully',
      data: { rental, quotation }
    });
  } catch (error) {
    console.error('Error converting quotation to rental:', error);
    res.status(500).json({ success: false, message: 'Failed to convert quotation to rental' });
  }
};

// All routes require admin authorization
router.use(protect, authorize('admin'));

router.get('/', getAllQuotations);
router.get('/stats', getQuotationStats);
router.get('/:id', getQuotationById);
router.post('/', createQuotation);
router.patch('/:id/status', updateQuotationStatus);
router.delete('/:id', deleteQuotation);
router.post('/:id/convert', convertToRental);

module.exports = router;
