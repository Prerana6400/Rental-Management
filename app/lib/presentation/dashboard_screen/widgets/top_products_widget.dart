import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopProductsWidget extends StatelessWidget {
  const TopProductsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topProducts = [
      {
        "id": 1,
        "name": "MacBook Pro 16\"",
        "category": "Electronics",
        "image":
            "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rank": 1,
        "revenue": "\$45,200",
        "rentals": 89,
      },
      {
        "id": 2,
        "name": "Tesla Model S",
        "category": "Vehicles",
        "image":
            "https://images.unsplash.com/photo-1560958089-b8a1929cea89?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rank": 2,
        "revenue": "\$38,750",
        "rentals": 67,
      },
      {
        "id": 3,
        "name": "Canon EOS R5",
        "category": "Electronics",
        "image":
            "https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rank": 3,
        "revenue": "\$32,100",
        "rentals": 54,
      },
      {
        "id": 4,
        "name": "Herman Miller Chair",
        "category": "Furniture",
        "image":
            "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rank": 4,
        "revenue": "\$28,900",
        "rentals": 43,
      },
      {
        "id": 5,
        "name": "DJI Mavic Pro",
        "category": "Electronics",
        "image":
            "https://images.unsplash.com/photo-1473968512647-3e447244af8f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "rank": 5,
        "revenue": "\$24,650",
        "rentals": 38,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Selling Products',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products-management-screen');
                },
                child: Text(
                  'View All',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 25.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: topProducts.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final product = topProducts[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: 45.w,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CustomImageWidget(
                  imageUrl: product["image"],
                  width: 45.w,
                  height: 12.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 2.w,
                left: 2.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: product["rank"] == 1
                        ? AppTheme.accentColor
                        : product["rank"] == 2
                            ? AppTheme.warningColor
                            : product["rank"] == 3
                                ? Color(0xFFCD7F32)
                                : AppTheme.textDisabled,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#${product["rank"]}',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["name"],
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    product["category"],
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Revenue',
                              style: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 9.sp,
                              ),
                            ),
                            Text(
                              product["revenue"],
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rentals',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 9.sp,
                            ),
                          ),
                          Text(
                            '${product["rentals"]}',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
