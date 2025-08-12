import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProductInventoryWidget extends StatelessWidget {
  final TextEditingController stockController;
  final TextEditingController lowStockController;
  final bool isAvailable;
  final Function(bool) onAvailabilityChanged;
  final String? stockError;
  final String? lowStockError;

  const ProductInventoryWidget({
    Key? key,
    required this.stockController,
    required this.lowStockController,
    required this.isAvailable,
    required this.onAvailabilityChanged,
    this.stockError,
    this.lowStockError,
  }) : super(key: key);

  Color _getStockStatusColor() {
    final currentStock = int.tryParse(stockController.text) ?? 0;
    final lowStockThreshold = int.tryParse(lowStockController.text) ?? 0;

    if (currentStock == 0) return AppTheme.errorColor;
    if (currentStock <= lowStockThreshold) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  String _getStockStatusText() {
    final currentStock = int.tryParse(stockController.text) ?? 0;
    final lowStockThreshold = int.tryParse(lowStockController.text) ?? 0;

    if (currentStock == 0) return 'Out of Stock';
    if (currentStock <= lowStockThreshold) return 'Low Stock';
    return 'In Stock';
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
            'Inventory Management',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          Row(
            children: [
              // Current Stock Field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Stock *',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: '0',
                        errorText: stockError,
                        suffixText: 'units',
                      ),
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Low Stock Threshold Field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Low Stock Alert',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: lowStockController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: '10',
                        errorText: lowStockError,
                        suffixText: 'units',
                      ),
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Stock Status Indicator
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _getStockStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStockStatusColor().withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: _getStockStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  _getStockStatusText(),
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: _getStockStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${stockController.text.isEmpty ? '0' : stockController.text} units',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Availability Toggle
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Availability',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isAvailable
                          ? 'Available for sale'
                          : 'Not available for sale',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isAvailable,
                  onChanged: onAvailabilityChanged,
                  activeColor: AppTheme.accentColor,
                  inactiveThumbColor:
                      AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  inactiveTrackColor: AppTheme.darkTheme.colorScheme.outline,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
