import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.darkTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                iconName: 'dashboard',
                label: 'Dashboard',
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                index: 1,
                iconName: 'receipt_long',
                label: 'Orders',
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                index: 2,
                iconName: 'inventory_2',
                label: 'Products',
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                index: 3,
                iconName: 'person',
                label: 'Profile',
                isActive: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconName,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(isActive ? 1.w : 0),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.accentColor.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: isActive
                      ? AppTheme.accentColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: isActive ? 26 : 24,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: isActive
                      ? AppTheme.accentColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
