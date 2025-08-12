import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ProductCategoryWidget extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;
  final String? categoryError;

  const ProductCategoryWidget({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.categoryError,
  }) : super(key: key);

  final List<Map<String, dynamic>> _categories = const [
    {
      "id": "electronics",
      "name": "Electronics",
      "subcategories": [
        {"id": "smartphones", "name": "Smartphones"},
        {"id": "laptops", "name": "Laptops"},
        {"id": "tablets", "name": "Tablets"},
        {"id": "accessories", "name": "Accessories"},
      ]
    },
    {
      "id": "furniture",
      "name": "Furniture",
      "subcategories": [
        {"id": "office", "name": "Office Furniture"},
        {"id": "home", "name": "Home Furniture"},
        {"id": "outdoor", "name": "Outdoor Furniture"},
      ]
    },
    {
      "id": "vehicles",
      "name": "Vehicles",
      "subcategories": [
        {"id": "cars", "name": "Cars"},
        {"id": "bikes", "name": "Bikes"},
        {"id": "trucks", "name": "Trucks"},
      ]
    },
    {
      "id": "equipment",
      "name": "Equipment",
      "subcategories": [
        {"id": "construction", "name": "Construction Equipment"},
        {"id": "medical", "name": "Medical Equipment"},
        {"id": "sports", "name": "Sports Equipment"},
      ]
    },
  ];

  void _showCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.darkTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Category',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(4.w),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return ExpansionTile(
                    title: Text(
                      category["name"] as String,
                      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    iconColor: AppTheme.accentColor,
                    collapsedIconColor:
                        AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    children: (category["subcategories"] as List)
                        .map<Widget>((subcategory) {
                      final subcategoryName = subcategory["name"] as String;
                      final isSelected = selectedCategory == subcategoryName;

                      return ListTile(
                        title: Text(
                          subcategoryName,
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? AppTheme.accentColor
                                : AppTheme.darkTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        trailing: isSelected
                            ? CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.accentColor,
                                size: 20,
                              )
                            : null,
                        onTap: () {
                          onCategoryChanged(subcategoryName);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Selection',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Category *',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () => _showCategoryModal(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: categoryError != null
                          ? AppTheme.errorColor
                          : AppTheme.darkTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedCategory ?? 'Select a category',
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: selectedCategory != null
                              ? AppTheme.darkTheme.colorScheme.onSurface
                              : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              if (categoryError != null)
                Padding(
                  padding: EdgeInsets.only(top: 1.h, left: 3.w),
                  child: Text(
                    categoryError!,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ),
            ],
          ),
          if (selectedCategory != null) ...[
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'category',
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Selected: $selectedCategory',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => onCategoryChanged(null),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
