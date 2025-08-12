import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onUpdateStatus;
  final VoidCallback? onTrack;
  final VoidCallback? onDelete;

  const OrderCardWidget({
    Key? key,
    required this.orderData,
    this.onTap,
    this.onViewDetails,
    this.onUpdateStatus,
    this.onTrack,
    this.onDelete,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningColor;
      case 'confirmed':
        return AppTheme.accentColor;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return AppTheme.successColor;
      case 'canceled':
        return AppTheme.errorColor;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String customerName =
        (orderData['customerName'] as String?) ?? 'Unknown Customer';
    final String orderNumber = (orderData['orderNumber'] as String?) ?? 'N/A';
    final double totalAmount =
        (orderData['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final String status = (orderData['status'] as String?) ?? 'pending';
    final DateTime orderDate =
        orderData['orderDate'] as DateTime? ?? DateTime.now();

    return Dismissible(
      key: Key(orderNumber),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              color: AppTheme.accentColor,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'View',
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.errorColor,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Delete',
              style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onViewDetails?.call();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
                  title: Text(
                    'Delete Order',
                    style: AppTheme.darkTheme.textTheme.titleLarge,
                  ),
                  content: Text(
                    'Are you sure you want to delete order $orderNumber?',
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onDelete?.call();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                    ),
                  ],
                ),
              ) ??
              false;
        }
        return false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.darkTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: () {
              _showContextMenu(context);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerName,
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Order #$orderNumber',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '\$${totalAmount.toStringAsFixed(2)}',
                            style: AppTheme.darkTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Order Date',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${orderDate.month.toString().padLeft(2, '0')}/${orderDate.day.toString().padLeft(2, '0')}/${orderDate.year}',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
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
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.accentColor,
                size: 24,
              ),
              title: Text(
                'View Details',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onViewDetails?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.warningColor,
                size: 24,
              ),
              title: Text(
                'Update Status',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onUpdateStatus?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_shipping',
                color: Colors.blue,
                size: 24,
              ),
              title: Text(
                'Track Order',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onTrack?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.errorColor,
                size: 24,
              ),
              title: Text(
                'Delete Order',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
