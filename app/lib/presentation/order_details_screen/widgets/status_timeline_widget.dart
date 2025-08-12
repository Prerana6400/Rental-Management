import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> statusHistory;
  final String currentStatus;

  const StatusTimelineWidget({
    Key? key,
    required this.statusHistory,
    required this.currentStatus,
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
        return AppTheme.darkTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.done_all;
      case 'canceled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
                  iconName: 'timeline',
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Order Timeline',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(currentStatus).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          _getStatusColor(currentStatus).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    currentStatus.toUpperCase(),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(currentStatus),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: statusHistory.length,
              itemBuilder: (context, index) {
                final statusItem = statusHistory[index];
                final status = statusItem['status'] as String;
                final timestamp = statusItem['timestamp'] as DateTime;
                final description = statusItem['description'] as String?;
                final isLast = index == statusHistory.length - 1;
                final isCurrent =
                    status.toLowerCase() == currentStatus.toLowerCase();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? _getStatusColor(status)
                                : _getStatusColor(status)
                                    .withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _getStatusColor(status),
                              width: isCurrent ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            _getStatusIcon(status),
                            size: 4.w,
                            color: isCurrent
                                ? Colors.white
                                : _getStatusColor(status),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 6.h,
                            color: AppTheme.darkTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                      ],
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.toUpperCase(),
                              style: AppTheme.darkTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isCurrent
                                    ? _getStatusColor(status)
                                    : AppTheme.darkTheme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDateTime(timestamp),
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .darkTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (description != null) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                description,
                                style: AppTheme.darkTheme.textTheme.bodySmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
