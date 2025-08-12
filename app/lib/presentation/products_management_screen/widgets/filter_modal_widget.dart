import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _categories = [
    'Electronics',
    'Furniture',
    'Vehicles',
    'Tools',
    'Sports Equipment',
    'Party Supplies',
    'Construction',
    'Photography',
  ];

  final List<String> _availabilityOptions = [
    'All Products',
    'Available Only',
    'Out of Stock',
    'Low Stock',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Products',
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: _clearAllFilters,
                          child: Text(
                            'Clear All',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        ElevatedButton(
                          onPressed: _applyFilters,
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  _buildFilterSection(
                    title: 'Categories',
                    isExpanded: _filters['categoriesExpanded'] ?? true,
                    onToggle: () => setState(() {
                      _filters['categoriesExpanded'] =
                          !(_filters['categoriesExpanded'] ?? true);
                    }),
                    child: _buildCategoriesFilter(),
                  ),

                  SizedBox(height: 3.h),

                  // Price Range Section
                  _buildFilterSection(
                    title: 'Price Range',
                    isExpanded: _filters['priceExpanded'] ?? false,
                    onToggle: () => setState(() {
                      _filters['priceExpanded'] =
                          !(_filters['priceExpanded'] ?? false);
                    }),
                    child: _buildPriceRangeFilter(),
                  ),

                  SizedBox(height: 3.h),

                  // Availability Section
                  _buildFilterSection(
                    title: 'Availability',
                    isExpanded: _filters['availabilityExpanded'] ?? false,
                    onToggle: () => setState(() {
                      _filters['availabilityExpanded'] =
                          !(_filters['availabilityExpanded'] ?? false);
                    }),
                    child: _buildAvailabilityFilter(),
                  ),

                  SizedBox(height: 3.h),

                  // Stock Level Section
                  _buildFilterSection(
                    title: 'Stock Level',
                    isExpanded: _filters['stockExpanded'] ?? false,
                    onToggle: () => setState(() {
                      _filters['stockExpanded'] =
                          !(_filters['stockExpanded'] ?? false);
                    }),
                    child: _buildStockLevelFilter(),
                  ),

                  SizedBox(height: 10.h), // Bottom padding for FAB
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondary,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: child,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoriesFilter() {
    final selectedCategories = (_filters['categories'] as List<String>?) ?? [];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _categories.map((category) {
        final isSelected = selectedCategories.contains(category);
        return FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedCategories.add(category);
              } else {
                selectedCategories.remove(category);
              }
              _filters['categories'] = selectedCategories;
            });
          },
          selectedColor: AppTheme.accentColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.accentColor,
          labelStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: isSelected ? AppTheme.accentColor : AppTheme.textPrimary,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeFilter() {
    final minPrice = (_filters['minPrice'] as double?) ?? 0.0;
    final maxPrice = (_filters['maxPrice'] as double?) ?? 10000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Min Price',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    initialValue: minPrice.toStringAsFixed(0),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      hintText: '0',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    ),
                    onChanged: (value) {
                      _filters['minPrice'] = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Max Price',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    initialValue: maxPrice.toStringAsFixed(0),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      hintText: '10000',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    ),
                    onChanged: (value) {
                      _filters['maxPrice'] = double.tryParse(value) ?? 10000.0;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            '\$${minPrice.toStringAsFixed(0)}',
            '\$${maxPrice.toStringAsFixed(0)}',
          ),
          onChanged: (values) {
            setState(() {
              _filters['minPrice'] = values.start;
              _filters['maxPrice'] = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAvailabilityFilter() {
    final selectedAvailability =
        _filters['availability'] as String? ?? 'All Products';

    return Column(
      children: _availabilityOptions.map((option) {
        return RadioListTile<String>(
          title: Text(
            option,
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          value: option,
          groupValue: selectedAvailability,
          onChanged: (value) {
            setState(() {
              _filters['availability'] = value;
            });
          },
          activeColor: AppTheme.accentColor,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildStockLevelFilter() {
    final minStock = (_filters['minStock'] as int?) ?? 0;
    final maxStock = (_filters['maxStock'] as int?) ?? 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Min Stock',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    initialValue: minStock.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '0',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    ),
                    onChanged: (value) {
                      _filters['minStock'] = int.tryParse(value) ?? 0;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Max Stock',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    initialValue: maxStock.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '1000',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    ),
                    onChanged: (value) {
                      _filters['maxStock'] = int.tryParse(value) ?? 1000;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
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
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  int get _activeFilterCount {
    int count = 0;

    final categories = (_filters['categories'] as List<String>?) ?? [];
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
}
