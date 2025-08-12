import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bulk_action_bar_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/search_bar_widget.dart';

class ProductsManagementScreen extends StatefulWidget {
  const ProductsManagementScreen({Key? key}) : super(key: key);

  @override
  State<ProductsManagementScreen> createState() =>
      _ProductsManagementScreenState();
}

class _ProductsManagementScreenState extends State<ProductsManagementScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  Map<String, dynamic> _filters = {
    'categories': <String>[],
    'minPrice': 0.0,
    'maxPrice': 10000.0,
    'availability': 'All Products',
    'minStock': 0,
    'maxStock': 1000,
    'categoriesExpanded': true,
    'priceExpanded': false,
    'availabilityExpanded': false,
    'stockExpanded': false,
  };

  Set<int> _selectedProducts = {};
  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  int _currentBottomNavIndex = 2; // Products tab

  // Mock product data
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": 1,
      "name": "Professional Camera Kit",
      "description":
          "High-end DSLR camera with multiple lenses and accessories for professional photography sessions.",
      "price": "\$299.99",
      "category": "Photography",
      "stock": 15,
      "sku": "CAM-001",
      "image":
          "https://images.unsplash.com/photo-1502920917128-1aa500764cbd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "name": "Wedding Tent Package",
      "description":
          "Large white tent suitable for outdoor weddings and events, includes setup and breakdown service.",
      "price": "\$899.99",
      "category": "Party Supplies",
      "stock": 3,
      "sku": "TENT-002",
      "image":
          "https://images.unsplash.com/photo-1519225421980-715cb0215aed?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "name": "Power Drill Set",
      "description":
          "Professional cordless power drill with multiple bits and carrying case for construction projects.",
      "price": "\$149.99",
      "category": "Tools",
      "stock": 25,
      "sku": "DRILL-003",
      "image":
          "https://images.unsplash.com/photo-1504148455328-c376907d081c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 4,
      "name": "Luxury Sofa Set",
      "description":
          "Elegant 3-piece leather sofa set perfect for upscale events and photo shoots.",
      "price": "\$599.99",
      "category": "Furniture",
      "stock": 8,
      "sku": "SOFA-004",
      "image":
          "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 5,
      "name": "Gaming Console Bundle",
      "description":
          "Latest gaming console with controllers and popular games for entertainment events.",
      "price": "\$199.99",
      "category": "Electronics",
      "stock": 0,
      "sku": "GAME-005",
      "image":
          "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 6,
      "name": "Mountain Bike",
      "description":
          "High-performance mountain bike suitable for outdoor adventures and sports events.",
      "price": "\$249.99",
      "category": "Sports Equipment",
      "stock": 12,
      "sku": "BIKE-006",
      "image":
          "https://images.unsplash.com/photo-1544191696-15693072b5a5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 7,
      "name": "Construction Scaffolding",
      "description":
          "Heavy-duty scaffolding system for construction and maintenance projects.",
      "price": "\$799.99",
      "category": "Construction",
      "stock": 5,
      "sku": "SCAF-007",
      "image":
          "https://images.unsplash.com/photo-1541888946425-d81bb19240f5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 8,
      "name": "DJ Sound System",
      "description":
          "Professional DJ equipment with speakers, mixer, and microphones for events and parties.",
      "price": "\$449.99",
      "category": "Electronics",
      "stock": 7,
      "sku": "DJ-008",
      "image":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final sku = (product['sku'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            sku.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply category filter
    final selectedCategories = (_filters['categories'] as List<String>);
    if (selectedCategories.isNotEmpty) {
      filtered = filtered.where((product) {
        return selectedCategories.contains(product['category']);
      }).toList();
    }

    // Apply price filter
    final minPrice = (_filters['minPrice'] as double?) ?? 0.0;
    final maxPrice = (_filters['maxPrice'] as double?) ?? 10000.0;
    filtered = filtered.where((product) {
      final priceStr =
          (product['price'] as String).replaceAll('\$', '').replaceAll(',', '');
      final price = double.tryParse(priceStr) ?? 0.0;
      return price >= minPrice && price <= maxPrice;
    }).toList();

    // Apply availability filter
    final availability = _filters['availability'] as String? ?? 'All Products';
    if (availability != 'All Products') {
      filtered = filtered.where((product) {
        final stock = product['stock'] as int;
        switch (availability) {
          case 'Available Only':
            return stock > 0;
          case 'Out of Stock':
            return stock == 0;
          case 'Low Stock':
            return stock > 0 && stock <= 10;
          default:
            return true;
        }
      }).toList();
    }

    // Apply stock level filter
    final minStock = (_filters['minStock'] as int?) ?? 0;
    final maxStock = (_filters['maxStock'] as int?) ?? 1000;
    filtered = filtered.where((product) {
      final stock = product['stock'] as int;
      return stock >= minStock && stock <= maxStock;
    }).toList();

    return filtered;
  }

  int get _activeFilterCount {
    int count = 0;

    final categories = (_filters['categories'] as List<String>);
    if (categories.isNotEmpty) count++;

    final minPrice = (_filters['minPrice'] as double?) ?? 0.0;
    final maxPrice = (_filters['maxPrice'] as double?) ?? 10000.0;
    if (minPrice > 0 || maxPrice < 10000) count++;

    final availability = _filters['availability'] as String? ?? 'All Products';
    if (availability != 'All Products') count++;

    final minStock = (_filters['minStock'] as int?) ?? 0;
    final maxStock = (_filters['maxStock'] as int?) ?? 1000;
    if (minStock > 0 || maxStock < 1000) count++;

    return count;
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshProducts() async {
    HapticFeedback.lightImpact();
    await _loadProducts();

    Fluttertoast.showToast(
      msg: "Products refreshed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
          });
        },
      ),
    );
  }

  void _onProductTap(Map<String, dynamic> product) {
    if (_isMultiSelectMode) {
      _toggleProductSelection(product['id'] as int);
    } else {
      Navigator.pushNamed(
        context,
        '/product-details-screen',
        arguments: product,
      );
    }
  }

  void _onProductLongPress(Map<String, dynamic> product) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isMultiSelectMode = true;
      _selectedProducts.add(product['id'] as int);
    });
  }

  void _toggleProductSelection(int productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
        if (_selectedProducts.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  void _selectAllProducts() {
    setState(() {
      _selectedProducts = _filteredProducts.map((p) => p['id'] as int).toSet();
    });
  }

  void _deselectAllProducts() {
    setState(() {
      _selectedProducts.clear();
      _isMultiSelectMode = false;
    });
  }

  void _showBulkDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.cardColor,
        title: Text(
          'Delete Products',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedProducts.length} selected products? This action cannot be undone.',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performBulkDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performBulkDelete() {
    final count = _selectedProducts.length;
    setState(() {
      _allProducts
          .removeWhere((product) => _selectedProducts.contains(product['id']));
      _selectedProducts.clear();
      _isMultiSelectMode = false;
    });

    Fluttertoast.showToast(
      msg: "$count products deleted successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
    );
  }

  void _showBulkCategoryChange() {
    final categories = [
      'Electronics',
      'Furniture',
      'Vehicles',
      'Tools',
      'Sports Equipment',
      'Party Supplies',
      'Construction',
      'Photography',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.cardColor,
        title: Text(
          'Change Category',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((category) {
            return ListTile(
              title: Text(
                category,
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                _performBulkCategoryChange(category);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _performBulkCategoryChange(String newCategory) {
    final count = _selectedProducts.length;
    setState(() {
      for (var product in _allProducts) {
        if (_selectedProducts.contains(product['id'])) {
          product['category'] = newCategory;
        }
      }
      _selectedProducts.clear();
      _isMultiSelectMode = false;
    });

    Fluttertoast.showToast(
      msg: "$count products moved to $newCategory",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
    );
  }

  void _performBulkExport() {
    final selectedProductsData = _allProducts
        .where((product) => _selectedProducts.contains(product['id']))
        .toList();

    // Simulate CSV export
    final csvContent = _generateCSV(selectedProductsData);

    setState(() {
      _selectedProducts.clear();
      _isMultiSelectMode = false;
    });

    Fluttertoast.showToast(
      msg: "${selectedProductsData.length} products exported successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
    );
  }

  String _generateCSV(List<Map<String, dynamic>> products) {
    final headers = ['ID', 'Name', 'Category', 'Price', 'Stock', 'SKU'];
    final rows = products.map((product) {
      return [
        product['id'].toString(),
        product['name'],
        product['category'],
        product['price'],
        product['stock'].toString(),
        product['sku'],
      ].join(',');
    }).toList();

    return [headers.join(','), ...rows].join('\n');
  }

  void _addNewProduct() {
    Navigator.pushNamed(context, '/product-details-screen');
  }

  void _editProduct(Map<String, dynamic> product) {
    Navigator.pushNamed(
      context,
      '/product-details-screen',
      arguments: product,
    );
  }

  void _duplicateProduct(Map<String, dynamic> product) {
    final duplicatedProduct = Map<String, dynamic>.from(product);
    duplicatedProduct['id'] = _allProducts.length + 1;
    duplicatedProduct['name'] = '${product['name']} (Copy)';
    duplicatedProduct['sku'] = '${product['sku']}-COPY';

    setState(() {
      _allProducts.add(duplicatedProduct);
    });

    Fluttertoast.showToast(
      msg: "Product duplicated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
    );
  }

  void _shareProduct(Map<String, dynamic> product) {
    Fluttertoast.showToast(
      msg: "Sharing ${product['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.accentColor,
      textColor: Colors.white,
    );
  }

  void _deleteProduct(Map<String, dynamic> product) {
    setState(() {
      _allProducts.removeWhere((p) => p['id'] == product['id']);
    });

    Fluttertoast.showToast(
      msg: "${product['name']} deleted successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
    );
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/orders-management-screen');
        break;
      case 2:
        // Current screen - Products
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;
    final isAllSelected = _selectedProducts.length == filteredProducts.length &&
        filteredProducts.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.darkTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Products Management',
          style: AppTheme.darkTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (_isMultiSelectMode)
            TextButton(
              onPressed: _deselectAllProducts,
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            )
          else
            IconButton(
              onPressed: () {
                // Additional menu options
              },
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.textPrimary,
                size: 6.w,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            searchQuery: _searchQuery,
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showFilterModal,
            activeFilterCount: _activeFilterCount,
          ),

          // Bulk Action Bar
          if (_isMultiSelectMode)
            BulkActionBarWidget(
              selectedCount: _selectedProducts.length,
              onSelectAll: _selectAllProducts,
              onDeselectAll: _deselectAllProducts,
              onBulkDelete: _showBulkDeleteConfirmation,
              onBulkCategoryChange: _showBulkCategoryChange,
              onBulkExport: _performBulkExport,
              isAllSelected: isAllSelected,
            ),

          // Products Grid
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentColor,
                    ),
                  )
                : filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshProducts,
                        color: AppTheme.accentColor,
                        backgroundColor: AppTheme.darkTheme.cardColor,
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(4.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4.w,
                            mainAxisSpacing: 4.w,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            final productId = product['id'] as int;

                            return ProductCardWidget(
                              product: product,
                              isSelected: _selectedProducts.contains(productId),
                              onTap: () => _onProductTap(product),
                              onLongPress: () => _onProductLongPress(product),
                              onEdit: () => _editProduct(product),
                              onDuplicate: () => _duplicateProduct(product),
                              onShare: () => _shareProduct(product),
                              onDelete: () => _deleteProduct(product),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _addNewProduct,
              backgroundColor: AppTheme.accentColor,
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryDark,
                size: 7.w,
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.darkTheme.cardColor,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.textSecondary,
        selectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentBottomNavIndex == 0
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'receipt_long',
              color: _currentBottomNavIndex == 1
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'inventory_2',
              color: _currentBottomNavIndex == 2
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomNavIndex == 3
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'inventory_2',
            color: AppTheme.textDisabled,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            _searchQuery.isNotEmpty || _activeFilterCount > 0
                ? 'No products found'
                : 'No products available',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty || _activeFilterCount > 0
                ? 'Try adjusting your search or filters'
                : 'Add your first product to get started',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          if (_searchQuery.isEmpty && _activeFilterCount == 0)
            ElevatedButton.icon(
              onPressed: _addNewProduct,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.primaryDark,
                size: 5.w,
              ),
              label: const Text('Add Product'),
            ),
        ],
      ),
    );
  }
}
