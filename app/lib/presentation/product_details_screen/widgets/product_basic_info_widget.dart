import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProductBasicInfoWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController descriptionController;
  final String? nameError;
  final String? skuError;
  final String? descriptionError;

  const ProductBasicInfoWidget({
    Key? key,
    required this.nameController,
    required this.skuController,
    required this.descriptionController,
    this.nameError,
    this.skuError,
    this.descriptionError,
  }) : super(key: key);

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
            'Basic Information',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.darkTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Product Name Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Name *',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: nameController,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: 'Enter product name',
                  errorText: nameError,
                  counterText: '${nameController.text.length}/100',
                  counterStyle:
                      AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // SKU Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SKU *',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: skuController,
                maxLength: 50,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Enter SKU code',
                  errorText: skuError,
                  counterText: '${skuController.text.length}/50',
                  counterStyle:
                      AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Description Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Enter product description',
                  errorText: descriptionError,
                  counterText: '${descriptionController.text.length}/500',
                  counterStyle:
                      AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  ),
                  alignLabelWithHint: true,
                ),
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.darkTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
