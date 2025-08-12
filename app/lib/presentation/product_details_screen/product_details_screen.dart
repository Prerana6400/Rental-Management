import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/product_basic_info_widget.dart';
import './widgets/product_category_widget.dart';
import './widgets/product_image_carousel_widget.dart';
import './widgets/product_inventory_widget.dart';
import './widgets/product_pricing_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();

  // State variables
  List<String> _productImages = [
    'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pixabay.com/photo/2016/03/27/19/32/laptop-1283368_1280.jpg',
  ];
  String? _selectedCategory;
  bool _isAvailable = true;
  bool _hasUnsavedChanges = false;
  bool _isLoading = false;

  // Error states
  String? _nameError;
  String? _skuError;
  String? _descriptionError;
  String? _costError;
  String? _sellingPriceError;
  String? _discountError;
  String? _stockError;
  String? _lowStockError;
  String? _categoryError;

  // Mock product data
  final Map<String, dynamic> _mockProduct = {
    "id": "PROD-001",
    "name": "Professional Laptop Stand",
    "sku": "LPS-2024-001",
    "description":
        "Ergonomic aluminum laptop stand designed for professional workspaces. Adjustable height and angle for optimal viewing comfort. Compatible with laptops up to 17 inches.",
    "cost": "45.00",
    "sellingPrice": "89.99",
    "discount": "10.0",
    "currentStock": "25",
    "lowStockThreshold": "5",
    "category": "Office Furniture",
    "isAvailable": true,
    "images": [
      "https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pixabay.com/photo/2016/03/27/19/32/laptop-1283368_1280.jpg",
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadProductData();
    _setupListeners();
  }

  void _loadProductData() {
    _nameController.text = _mockProduct["name"] as String;
    _skuController.text = _mockProduct["sku"] as String;
    _descriptionController.text = _mockProduct["description"] as String;
    _costController.text = _mockProduct["cost"] as String;
    _sellingPriceController.text = _mockProduct["sellingPrice"] as String;
    _discountController.text = _mockProduct["discount"] as String;
    _stockController.text = _mockProduct["currentStock"] as String;
    _lowStockController.text = _mockProduct["lowStockThreshold"] as String;
    _selectedCategory = _mockProduct["category"] as String;
    _isAvailable = _mockProduct["isAvailable"] as bool;
    _productImages = List<String>.from(_mockProduct["images"] as List);
  }

  void _setupListeners() {
    _nameController.addListener(_onFieldChanged);
    _skuController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _costController.addListener(_onFieldChanged);
    _sellingPriceController.addListener(_onFieldChanged);
    _discountController.addListener(_onFieldChanged);
    _stockController.addListener(_onFieldChanged);
    _lowStockController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
    _clearErrors();
  }

  void _clearErrors() {
    setState(() {
      _nameError = null;
      _skuError = null;
      _descriptionError = null;
      _costError = null;
      _sellingPriceError = null;
      _discountError = null;
      _stockError = null;
      _lowStockError = null;
      _categoryError = null;
    });
  }

  bool _validateForm() {
    bool isValid = true;

    if (_nameController.text.trim().isEmpty) {
      _nameError = 'Product name is required';
      isValid = false;
    }

    if (_skuController.text.trim().isEmpty) {
      _skuError = 'SKU is required';
      isValid = false;
    }

    if (_costController.text.trim().isEmpty) {
      _costError = 'Cost price is required';
      isValid = false;
    } else {
      final cost = double.tryParse(_costController.text);
      if (cost == null || cost < 0) {
        _costError = 'Enter a valid cost price';
        isValid = false;
      }
    }

    if (_sellingPriceController.text.trim().isEmpty) {
      _sellingPriceError = 'Selling price is required';
      isValid = false;
    } else {
      final sellingPrice = double.tryParse(_sellingPriceController.text);
      if (sellingPrice == null || sellingPrice < 0) {
        _sellingPriceError = 'Enter a valid selling price';
        isValid = false;
      }
    }

    if (_stockController.text.trim().isEmpty) {
      _stockError = 'Stock quantity is required';
      isValid = false;
    } else {
      final stock = int.tryParse(_stockController.text);
      if (stock == null || stock < 0) {
        _stockError = 'Enter a valid stock quantity';
        isValid = false;
      }
    }

    if (_lowStockController.text.trim().isEmpty) {
      _lowStockError = 'Low stock threshold is required';
      isValid = false;
    } else {
      final lowStock = int.tryParse(_lowStockController.text);
      if (lowStock == null || lowStock < 0) {
        _lowStockError = 'Enter a valid threshold';
        isValid = false;
      }
    }

    if (_selectedCategory == null) {
      _categoryError = 'Please select a category';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  double get _calculatedProfit {
    final cost = double.tryParse(_costController.text) ?? 0;
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0;
    return sellingPrice - cost;
  }

  double get _finalPrice {
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    return sellingPrice - (sellingPrice * discount / 100);
  }

  Future<void> _saveProduct() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Product updated successfully!',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Delete Product',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this product? This action cannot be undone and will affect any existing orders.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.darkTheme.colorScheme.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacementNamed(context, '/products-management-screen');
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        title: Text(
          'Unsaved Changes',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You have unsaved changes. Do you want to discard them?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Keep Editing',
              style: TextStyle(color: AppTheme.accentColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.darkTheme.appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.darkTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          title: Text(
            'Product Details',
            style: AppTheme.darkTheme.appBarTheme.titleTextStyle,
          ),
          actions: [
            PopupMenuButton<String>(
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.darkTheme.colorScheme.onSurface,
                size: 24,
              ),
              color: AppTheme.darkTheme.colorScheme.surface,
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteProduct();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'delete',
                        color: AppTheme.errorColor,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Delete Product',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Images
                    ProductImageCarouselWidget(
                      images: _productImages,
                      onImagesChanged: (images) {
                        setState(() {
                          _productImages = images;
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Basic Information
                    ProductBasicInfoWidget(
                      nameController: _nameController,
                      skuController: _skuController,
                      descriptionController: _descriptionController,
                      nameError: _nameError,
                      skuError: _skuError,
                      descriptionError: _descriptionError,
                    ),

                    SizedBox(height: 4.h),

                    // Pricing Information
                    ProductPricingWidget(
                      costController: _costController,
                      sellingPriceController: _sellingPriceController,
                      discountController: _discountController,
                      costError: _costError,
                      sellingPriceError: _sellingPriceError,
                      discountError: _discountError,
                      calculatedProfit: _calculatedProfit,
                      finalPrice: _finalPrice,
                    ),

                    SizedBox(height: 4.h),

                    // Inventory Management
                    ProductInventoryWidget(
                      stockController: _stockController,
                      lowStockController: _lowStockController,
                      isAvailable: _isAvailable,
                      onAvailabilityChanged: (value) {
                        setState(() {
                          _isAvailable = value;
                          _hasUnsavedChanges = true;
                        });
                      },
                      stockError: _stockError,
                      lowStockError: _lowStockError,
                    ),

                    SizedBox(height: 4.h),

                    // Category Selection
                    ProductCategoryWidget(
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (category) {
                        setState(() {
                          _selectedCategory = category;
                          _hasUnsavedChanges = true;
                          _categoryError = null;
                        });
                      },
                      categoryError: _categoryError,
                    ),

                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppTheme.accentColor,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Saving changes...',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.darkTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: AppTheme.darkTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _hasUnsavedChanges
                        ? () async {
                            if (await _onWillPop()) {
                              Navigator.pop(context);
                            }
                          }
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      side: BorderSide(
                        color: _hasUnsavedChanges
                            ? AppTheme.errorColor
                            : AppTheme.darkTheme.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      _hasUnsavedChanges ? 'Discard' : 'Cancel',
                      style: TextStyle(
                        color: _hasUnsavedChanges
                            ? AppTheme.errorColor
                            : AppTheme.darkTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      foregroundColor: AppTheme.darkTheme.colorScheme.surface,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      elevation: 2,
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _sellingPriceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }
}
