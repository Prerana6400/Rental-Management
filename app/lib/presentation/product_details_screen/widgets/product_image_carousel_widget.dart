import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ProductImageCarouselWidget extends StatefulWidget {
  final List<String> images;
  final Function(List<String>) onImagesChanged;

  const ProductImageCarouselWidget({
    Key? key,
    required this.images,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<ProductImageCarouselWidget> createState() =>
      _ProductImageCarouselWidgetState();
}

class _ProductImageCarouselWidgetState
    extends State<ProductImageCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _addImage() {
    // Mock image addition - in real app would use image picker
    final newImages = List<String>.from(widget.images);
    newImages.add(
        'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
    widget.onImagesChanged(newImages);
  }

  void _removeImage(int index) {
    if (widget.images.length > 1) {
      final newImages = List<String>.from(widget.images);
      newImages.removeAt(index);
      widget.onImagesChanged(newImages);

      if (_currentIndex >= newImages.length) {
        setState(() {
          _currentIndex = newImages.length - 1;
        });
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(2.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: widget.images[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 2.h,
                  right: 4.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.surface
                          .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _addImage,
                          icon: CustomIconWidget(
                            iconName: 'add_a_photo',
                            color: AppTheme.accentColor,
                            size: 20,
                          ),
                        ),
                        if (widget.images.length > 1)
                          IconButton(
                            onPressed: () => _removeImage(_currentIndex),
                            icon: CustomIconWidget(
                              iconName: 'delete',
                              color: AppTheme.errorColor,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.images.length > 1)
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    width: _currentIndex == index ? 3.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppTheme.accentColor
                          : AppTheme.darkTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
