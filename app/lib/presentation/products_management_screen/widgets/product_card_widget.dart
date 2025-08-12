import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final bool isSelected;
  final VoidCallback? onLongPress;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
    this.onDelete,
    this.isSelected = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockLevel = product['stock'] as int? ?? 0;
    final price = product['price'] as String? ?? '\$0.00';
    final name = product['name'] as String? ?? 'Unknown Product';
    final imageUrl = product['image'] as String? ?? '';
    final category = product['category'] as String? ?? 'General';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key('product_${product['id']}'),
        background: _buildSwipeBackground(isLeftSwipe: false),
        secondaryBackground: _buildSwipeBackground(isLeftSwipe: true),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            // Right swipe - Edit actions
            _showActionSheet(context, showEdit: true);
          } else {
            // Left swipe - Delete action
            _showDeleteConfirmation(context);
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _showActionSheet(context, showEdit: true);
            return false;
          } else {
            return await _showDeleteConfirmation(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accentColor.withValues(alpha: 0.1)
                : AppTheme.darkTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppTheme.accentColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowDark,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 20.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  color: AppTheme.darkTheme.colorScheme.surface,
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: imageUrl.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: 20.h,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppTheme.darkTheme.colorScheme.surface,
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'image',
                              color: AppTheme.textSecondary,
                              size: 8.w,
                            ),
                          ),
                        ),
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        name,
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Category
                      Text(
                        category,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Price
                      Text(
                        price,
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      // Stock Level Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color:
                              _getStockColor(stockLevel).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getStockColor(stockLevel),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                color: _getStockColor(stockLevel),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              _getStockText(stockLevel),
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getStockColor(stockLevel),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeftSwipe}) {
    return Container(
      decoration: BoxDecoration(
        color: isLeftSwipe ? AppTheme.errorColor : AppTheme.accentColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeftSwipe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeftSwipe ? 'delete' : 'edit',
                color: Colors.white,
                size: 6.w,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeftSwipe ? 'Delete' : 'Edit',
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, {required bool showEdit}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.accentColor,
                size: 6.w,
              ),
              title: Text(
                'Edit Product',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.accentColor,
                size: 6.w,
              ),
              title: Text(
                'Duplicate Product',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onDuplicate?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.accentColor,
                size: 6.w,
              ),
              title: Text(
                'Share Product',
                style: AppTheme.darkTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.darkTheme.cardColor,
            title: Text(
              'Delete Product',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            content: Text(
              'Are you sure you want to delete "${product['name']}"? This action cannot be undone.',
              style: AppTheme.darkTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  onDelete?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Color _getStockColor(int stock) {
    if (stock <= 0) return AppTheme.errorColor;
    if (stock <= 10) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  String _getStockText(int stock) {
    if (stock <= 0) return 'Out of Stock';
    if (stock <= 10) return 'Low Stock ($stock)';
    return 'In Stock ($stock)';
  }
}
