import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsSection extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusUpdate;
  final Function(String) onTrackingUpdate;
  final VoidCallback onSendInvoice;
  final VoidCallback onShareOrder;

  const ActionButtonsSection({
    Key? key,
    required this.currentStatus,
    required this.onStatusUpdate,
    required this.onTrackingUpdate,
    required this.onSendInvoice,
    required this.onShareOrder,
  }) : super(key: key);

  void _showStatusUpdateBottomSheet(BuildContext context) {
    final List<String> availableStatuses = [
      'Pending',
      'Confirmed',
      'Shipped',
      'Delivered',
      'Canceled'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Update Order Status',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              ...availableStatuses.map((status) {
                final isCurrentStatus =
                    status.toLowerCase() == currentStatus.toLowerCase();
                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isCurrentStatus
                            ? AppTheme.accentColor.withValues(alpha: 0.2)
                            : AppTheme.darkTheme.colorScheme.surface
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: isCurrentStatus
                            ? 'check_circle'
                            : 'radio_button_unchecked',
                        color: isCurrentStatus
                            ? AppTheme.accentColor
                            : AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      status,
                      style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isCurrentStatus ? FontWeight.w600 : FontWeight.w400,
                        color: isCurrentStatus
                            ? AppTheme.accentColor
                            : AppTheme.darkTheme.colorScheme.onSurface,
                      ),
                    ),
                    onTap: isCurrentStatus
                        ? null
                        : () {
                            Navigator.pop(context);
                            _showConfirmationDialog(context, status);
                          },
                    enabled: !isCurrentStatus,
                  ),
                );
              }).toList(),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String newStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.colorScheme.surface,
          title: Text(
            'Confirm Status Update',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to update the order status to "$newStatus"?',
            style: AppTheme.darkTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onStatusUpdate(newStatus);
                Fluttertoast.showToast(
                  msg: 'Order status updated to $newStatus',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showTrackingDialog(BuildContext context) {
    final TextEditingController trackingController = TextEditingController();
    String selectedCarrier = 'FedEx';
    final List<String> carriers = ['FedEx', 'UPS', 'DHL', 'USPS', 'Other'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppTheme.darkTheme.colorScheme.surface,
              title: Text(
                'Add Tracking Number',
                style: AppTheme.darkTheme.textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCarrier,
                    decoration: InputDecoration(
                      labelText: 'Carrier',
                      labelStyle: AppTheme.darkTheme.textTheme.bodyMedium,
                    ),
                    dropdownColor: AppTheme.darkTheme.colorScheme.surface,
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                    items: carriers.map((String carrier) {
                      return DropdownMenuItem<String>(
                        value: carrier,
                        child: Text(carrier),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCarrier = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: trackingController,
                    decoration: InputDecoration(
                      labelText: 'Tracking Number',
                      labelStyle: AppTheme.darkTheme.textTheme.bodyMedium,
                      hintText: 'Enter tracking number',
                    ),
                    style: AppTheme.darkTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (trackingController.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      onTrackingUpdate(
                          '$selectedCarrier: ${trackingController.text}');
                      Fluttertoast.showToast(
                        msg: 'Tracking number added successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  child: Text('Add Tracking'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showStatusUpdateBottomSheet(context),
                    icon: CustomIconWidget(
                      iconName: 'update',
                      color: AppTheme.darkTheme.colorScheme.onPrimary,
                      size: 18,
                    ),
                    label: Text('Update Status'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showTrackingDialog(context),
                    icon: CustomIconWidget(
                      iconName: 'local_shipping',
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                    label: Text('Add Tracking'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: onSendInvoice,
                    icon: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                    label: Text('Send Invoice'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onShareOrder,
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.accentColor,
                      size: 18,
                    ),
                    label: Text('Share Order'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
