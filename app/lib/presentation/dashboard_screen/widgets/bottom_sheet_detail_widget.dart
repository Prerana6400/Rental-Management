import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomSheetDetailWidget extends StatelessWidget {
  final String title;
  final String value;
  final String growthPercentage;
  final bool isPositiveGrowth;

  const BottomSheetDetailWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.growthPercentage,
    required this.isPositiveGrowth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> detailBreakdown = _getDetailBreakdown();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textDisabled,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$title Breakdown',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.textSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.dividerSubtle,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total $title',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      value,
                      style:
                          AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName:
                          isPositiveGrowth ? 'trending_up' : 'trending_down',
                      color: isPositiveGrowth
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '$growthPercentage% vs last period',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: isPositiveGrowth
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Detailed Breakdown',
            style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detailBreakdown.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final item = detailBreakdown[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.dividerSubtle.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: Color(int.parse(item["color"])),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["label"],
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item["description"],
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item["value"],
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${item["percentage"]}%',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDetailBreakdown() {
    if (title.contains('Sales')) {
      return [
        {
          "label": "Electronics",
          "description": "Laptops, cameras, phones",
          "value": "\$45,200",
          "percentage": "35",
          "color": "0xFF00BFA5",
        },
        {
          "label": "Vehicles",
          "description": "Cars, bikes, trucks",
          "value": "\$38,750",
          "percentage": "30",
          "color": "0xFFFF9800",
        },
        {
          "label": "Furniture",
          "description": "Chairs, tables, decor",
          "value": "\$25,100",
          "percentage": "20",
          "color": "0xFF4CAF50",
        },
        {
          "label": "Others",
          "description": "Miscellaneous items",
          "value": "\$19,450",
          "percentage": "15",
          "color": "0xFFF44336",
        },
      ];
    } else if (title.contains('Users')) {
      return [
        {
          "label": "New Users",
          "description": "First-time registrations",
          "value": "2,847",
          "percentage": "45",
          "color": "0xFF00BFA5",
        },
        {
          "label": "Returning Users",
          "description": "Previous customers",
          "value": "2,156",
          "percentage": "34",
          "color": "0xFFFF9800",
        },
        {
          "label": "Premium Users",
          "description": "Subscription holders",
          "value": "1,329",
          "percentage": "21",
          "color": "0xFF4CAF50",
        },
      ];
    } else {
      return [
        {
          "label": "Pending Orders",
          "description": "Awaiting confirmation",
          "value": "156",
          "percentage": "28",
          "color": "0xFFFF9800",
        },
        {
          "label": "Active Orders",
          "description": "Currently rented",
          "value": "289",
          "percentage": "52",
          "color": "0xFF4CAF50",
        },
        {
          "label": "Completed Orders",
          "description": "Successfully returned",
          "value": "111",
          "percentage": "20",
          "color": "0xFF00BFA5",
        },
      ];
    }
  }
}
