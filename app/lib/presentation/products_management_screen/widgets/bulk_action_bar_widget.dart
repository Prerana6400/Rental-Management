import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionBarWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onBulkDelete;
  final VoidCallback onBulkCategoryChange;
  final VoidCallback onBulkExport;
  final bool isAllSelected;

  const BulkActionBarWidget({
    Key? key,
    required this.selectedCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onBulkDelete,
    required this.onBulkCategoryChange,
    required this.onBulkExport,
    this.isAllSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: selectedCount > 0 ? 12.h : 0,
      child: selectedCount > 0
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                border: Border(
                  top: BorderSide(
                    color: AppTheme.accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Selection Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$selectedCount selected',
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: isAllSelected ? onDeselectAll : onSelectAll,
                          child: Text(
                            isAllSelected ? 'Deselect all' : 'Select all',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Row(
                    children: [
                      // Export Button
                      _buildActionButton(
                        icon: 'file_download',
                        onTap: onBulkExport,
                        tooltip: 'Export Selected',
                      ),

                      SizedBox(width: 2.w),

                      // Category Change Button
                      _buildActionButton(
                        icon: 'category',
                        onTap: onBulkCategoryChange,
                        tooltip: 'Change Category',
                      ),

                      SizedBox(width: 2.w),

                      // Delete Button
                      _buildActionButton(
                        icon: 'delete',
                        onTap: onBulkDelete,
                        tooltip: 'Delete Selected',
                        isDestructive: true,
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isDestructive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            color: isDestructive
                ? AppTheme.errorColor.withValues(alpha: 0.1)
                : AppTheme.darkTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDestructive
                  ? AppTheme.errorColor.withValues(alpha: 0.3)
                  : AppTheme.dividerSubtle,
              width: 1,
            ),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isDestructive ? AppTheme.errorColor : AppTheme.textSecondary,
            size: 5.w,
          ),
        ),
      ),
    );
  }
}
