import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PricingBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> pricingData;

  const PricingBreakdownCard({
    Key? key,
    required this.pricingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtotal = pricingData['subtotal'] as double? ?? 0.0;
    final tax = pricingData['tax'] as double? ?? 0.0;
    final discount = pricingData['discount'] as double? ?? 0.0;
    final shipping = pricingData['shipping'] as double? ?? 0.0;
    final total = pricingData['total'] as double? ?? 0.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'receipt',
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Pricing Breakdown',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.darkTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', subtotal, false),
                  SizedBox(height: 1.h),
                  _buildPriceRow('Tax', tax, false),
                  if (discount > 0) ...[
                    SizedBox(height: 1.h),
                    _buildPriceRow('Discount', -discount, false,
                        isDiscount: true),
                  ],
                  if (shipping > 0) ...[
                    SizedBox(height: 1.h),
                    _buildPriceRow('Shipping', shipping, false),
                  ],
                  SizedBox(height: 1.h),
                  Divider(
                    color: AppTheme.darkTheme.colorScheme.outline
                        .withValues(alpha: 0.5),
                    thickness: 1,
                  ),
                  SizedBox(height: 1.h),
                  _buildPriceRow('Total', total, true),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.accentColor,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Payment Method: ${pricingData['paymentMethod'] as String? ?? 'Credit Card'}',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, bool isTotal,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )
              : AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        Text(
          isDiscount
              ? '-\$ ${amount.abs().toStringAsFixed(2)}'
              : '\$ ${amount.toStringAsFixed(2)}',
          style: isTotal
              ? AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentColor,
                )
              : AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDiscount
                      ? AppTheme.successColor
                      : AppTheme.darkTheme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
