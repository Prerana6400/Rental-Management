const express = require('express');
const Product = require('../models/Product');
const { protect, authorize } = require('../middleware/auth');
const router = express.Router();

// Helper function to generate unique ID for add-ons
const generateAddOnId = () => `addon_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

// @desc    Get all products
// @route   GET /api/products
// @access  Public
const getProducts = async (req, res) => {
  try {
    const { 
      category, 
      availability, 
      search, 
      page = 1, 
      limit = 10,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // Build filter object
    const filter = { isActive: true };
    
    if (category) {
      filter.category = { $regex: category, $options: 'i' };
    }
    
    if (availability) {
      filter.availability = availability;
    }
    
    if (search) {
      filter.$text = { $search: search };
    }

    // Build sort object
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // Calculate pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);

    const products = await Product.find(filter)
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit))
      .populate('createdBy', 'name email')
      .populate('updatedBy', 'name email');

    const total = await Product.countDocuments(filter);

    res.json({
      success: true,
      data: {
        products,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        }
      }
    });
  } catch (error) {
    console.error('Get products error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching products'
    });
  }
};

// @desc    Get single product
// @route   GET /api/products/:id
// @access  Public
const getProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id)
      .populate('createdBy', 'name email')
      .populate('updatedBy', 'name email');

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }

    res.json({
      success: true,
      data: { product }
    });
  } catch (error) {
    console.error('Get product error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching product'
    });
  }
};

// @desc    Create new product
// @route   POST /api/products
// @access  Private (Admin only)
const createProduct = async (req, res) => {
  try {
    const {
      name,
      category,
      description,
      image,
      pricePerHour,
      pricePerDay,
      pricePerWeek,
      features,
      addOns,
      availability,
      location
    } = req.body;

    // Validate required fields
    if (!name || !category || !description) {
      return res.status(400).json({
        success: false,
        message: 'Name, category, and description are required'
      });
    }

    // Process add-ons to ensure they have IDs
    const processedAddOns = (addOns || []).map(addOn => ({
      id: addOn.id || generateAddOnId(),
      name: addOn.name,
      price: addOn.price
    }));

    // Filter out empty features
    const processedFeatures = (features || []).filter(f => f.trim());

    const productData = {
      name: name.trim(),
      category: category.trim(),
      description: description.trim(),
      image: image || '',
      pricePerHour: parseFloat(pricePerHour) || 0,
      pricePerDay: parseFloat(pricePerDay) || 0,
      pricePerWeek: parseFloat(pricePerWeek) || 0,
      features: processedFeatures,
      addOns: processedAddOns,
      availability: availability || 'available',
      location: location || {},
      createdBy: req.user.id
    };

    const product = await Product.create(productData);

    const populatedProduct = await Product.findById(product._id)
      .populate('createdBy', 'name email');

    res.status(201).json({
      success: true,
      message: 'Product created successfully',
      data: { product: populatedProduct }
    });
  } catch (error) {
    console.error('Create product error:', error);
    
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
      message: 'Server error while creating product'
    });
  }
};

// @desc    Update product
// @route   PUT /api/products/:id
// @access  Private (Admin only)
const updateProduct = async (req, res) => {
  try {
    const {
      name,
      category,
      description,
      image,
      pricePerHour,
      pricePerDay,
      pricePerWeek,
      features,
      addOns,
      availability,
      location
    } = req.body;

    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }

    // Process add-ons to ensure they have IDs
    const processedAddOns = (addOns || []).map(addOn => ({
      id: addOn.id || generateAddOnId(),
      name: addOn.name,
      price: addOn.price
    }));

    // Filter out empty features
    const processedFeatures = (features || []).filter(f => f.trim());

    const updateData = {
      name: name ? name.trim() : product.name,
      category: category ? category.trim() : product.category,
      description: description ? description.trim() : product.description,
      image: image !== undefined ? image : product.image,
      pricePerHour: pricePerHour !== undefined ? parseFloat(pricePerHour) : product.pricePerHour,
      pricePerDay: pricePerDay !== undefined ? parseFloat(pricePerDay) : product.pricePerDay,
      pricePerWeek: pricePerWeek !== undefined ? parseFloat(pricePerWeek) : product.pricePerWeek,
      features: processedFeatures,
      addOns: processedAddOns,
      availability: availability || product.availability,
      location: location || product.location,
      updatedBy: req.user.id
    };

    const updatedProduct = await Product.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true }
    ).populate('createdBy', 'name email')
     .populate('updatedBy', 'name email');

    res.json({
      success: true,
      message: 'Product updated successfully',
      data: { product: updatedProduct }
    });
  } catch (error) {
    console.error('Update product error:', error);
    
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
      message: 'Server error while updating product'
    });
  }
};

// @desc    Delete product
// @route   DELETE /api/products/:id
// @access  Private (Admin only)
const deleteProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }

    // Soft delete - set isActive to false
    product.isActive = false;
    product.updatedBy = req.user.id;
    await product.save();

    res.json({
      success: true,
      message: 'Product deleted successfully'
    });
  } catch (error) {
    console.error('Delete product error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while deleting product'
    });
  }
};

// @desc    Toggle product availability
// @route   PATCH /api/products/:id/availability
// @access  Private (Admin only)
const toggleAvailability = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found'
      });
    }

    product.availability = product.availability === 'available' ? 'booked' : 'available';
    product.updatedBy = req.user.id;
    await product.save();

    res.json({
      success: true,
      message: `Product ${product.availability}`,
      data: { product }
    });
  } catch (error) {
    console.error('Toggle availability error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while toggling availability'
    });
  }
};

// @desc    Get product categories
// @route   GET /api/products/categories
// @access  Public
const getCategories = async (req, res) => {
  try {
    const categories = await Product.distinct('category');
    
    res.json({
      success: true,
      data: { categories }
    });
  } catch (error) {
    console.error('Get categories error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error while fetching categories'
    });
  }
};

// Routes
router.get('/', getProducts);
router.get('/categories', getCategories);
router.get('/:id', getProduct);

// Protected routes (admin only)
router.post('/', protect, authorize('admin'), createProduct);
router.put('/:id', protect, authorize('admin'), updateProduct);
router.delete('/:id', protect, authorize('admin'), deleteProduct);
router.patch('/:id/availability', protect, authorize('admin'), toggleAvailability);

module.exports = router;
