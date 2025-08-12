import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderItemsSection extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final Function(int, int) onQuantityChanged;
  final Function(int, double) onPriceChanged;

  const OrderItemsSection({
    Key? key,
    required this.orderItems,
    required this.onQuantityChanged,
    required this.onPriceChanged,
  }) : super(key: key);

  @override
  State<OrderItemsSection> createState() => _OrderItemsSectionState();
}

class _OrderItemsSectionState extends State<OrderItemsSection> {
  int? expandedIndex;

  void _showEditDialog(int index, Map<String, dynamic> item) {
    final TextEditingController quantityController = TextEditingController(
      text: (item['quantity'] as int).toString(),
    );
    final TextEditingController priceController = TextEditingController(
      text: (item['price'] as double).toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.colorScheme.surface,
          title: Text(
            'Edit Item',
            style: AppTheme.darkTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: AppTheme.darkTheme.textTheme.bodyMedium,
                ),
                style: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: AppTheme.darkTheme.textTheme.bodyMedium,
                  prefixText: '\$ ',
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
                final newQuantity = int.tryParse(quantityController.text) ??
                    item['quantity'] as int;
                final newPrice = double.tryParse(priceController.text) ??
                    item['price'] as double;

                widget.onQuantityChanged(index, newQuantity);
                widget.onPriceChanged(index, newPrice);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
                  iconName: 'shopping_cart',
                  color: AppTheme.accentColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Order Items (${widget.orderItems.length})',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.orderItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final item = widget.orderItems[index];
                final isExpanded = expandedIndex == index;

                return GestureDetector(
                  onLongPress: () => _showEditDialog(index, item),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isExpanded
                            ? AppTheme.accentColor.withValues(alpha: 0.5)
                            : AppTheme.darkTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                imageUrl: item['image'] as String? ?? '',
                                width: 15.w,
                                height: 15.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] as String? ?? 'Unknown Item',
                                    style: AppTheme
                                        .darkTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Row(
                                    children: [
                                      Text(
                                        'Qty: ${item['quantity']}',
                                        style: AppTheme
                                            .darkTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.darkTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '\$ ${(item['price'] as double).toStringAsFixed(2)}',
                                        style: AppTheme
                                            .darkTheme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: AppTheme.accentColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  expandedIndex = isExpanded ? null : index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.w),
                                child: AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: Duration(milliseconds: 300),
                                  child: CustomIconWidget(
                                    iconName: 'expand_more',
                                    color: AppTheme
                                        .darkTheme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isExpanded) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.darkTheme.colorScheme.surface
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item['description'] != null) ...[
                                  Text(
                                    'Description:',
                                    style: AppTheme
                                        .darkTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    item['description'] as String,
                                    style:
                                        AppTheme.darkTheme.textTheme.bodySmall,
                                  ),
                                  SizedBox(height: 1.h),
                                ],
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Unit Price: \$ ${(item['price'] as double).toStringAsFixed(2)}',
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      'Total: \$ ${((item['quantity'] as int) * (item['price'] as double)).toStringAsFixed(2)}',
                                      style: AppTheme
                                          .darkTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.accentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
