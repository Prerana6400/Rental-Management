import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  final List<String> _statusOptions = [
    'All',
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Canceled'
  ];
  final List<String> _dateRangeOptions = [
    'All Time',
    'Today',
    'This Week',
    'This Month',
    'Last 30 Days',
    'Custom Range'
  ];

  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _customerController.text = (_filters['customer'] as String?) ?? '';
    _minAmountController.text =
        (_filters['minAmount'] as double?)?.toString() ?? '';
    _maxAmountController.text =
        (_filters['maxAmount'] as double?)?.toString() ?? '';
    _startDate = _filters['startDate'] as DateTime?;
    _endDate = _filters['endDate'] as DateTime?;
  }

  @override
  void dispose() {
    _customerController.dispose();
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if ((_filters['status'] as String?) != null &&
        (_filters['status'] as String?) != 'All') count++;
    if ((_filters['dateRange'] as String?) != null &&
        (_filters['dateRange'] as String?) != 'All Time') count++;
    if ((_filters['customer'] as String?)?.isNotEmpty == true) count++;
    if ((_filters['minAmount'] as double?) != null ||
        (_filters['maxAmount'] as double?) != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _filters['status'] = 'All';
      _filters['dateRange'] = 'All Time';
      _customerController.clear();
      _minAmountController.clear();
      _maxAmountController.clear();
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    _filters['customer'] = _customerController.text.trim();
    _filters['minAmount'] = _minAmountController.text.isNotEmpty
        ? double.tryParse(_minAmountController.text)
        : null;
    _filters['maxAmount'] = _maxAmountController.text.isNotEmpty
        ? double.tryParse(_maxAmountController.text)
        : null;
    _filters['startDate'] = _startDate;
    _filters['endDate'] = _endDate;

    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme,
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _filters['dateRange'] = 'Custom Range';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Orders',
                      style:
                          AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        if (_getActiveFiltersCount() > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.accentColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_getActiveFiltersCount()} active',
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        SizedBox(width: 2.w),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Filter
                  _buildFilterSection(
                    title: 'Order Status',
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _statusOptions.map((status) {
                        final isSelected =
                            (_filters['status'] as String?) == status;
                        return FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _filters['status'] = selected ? status : 'All';
                            });
                          },
                          backgroundColor: AppTheme.darkTheme.cardColor,
                          selectedColor:
                              AppTheme.accentColor.withValues(alpha: 0.2),
                          labelStyle:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppTheme.accentColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.accentColor
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Date Range Filter
                  _buildFilterSection(
                    title: 'Date Range',
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 2.w,
                          runSpacing: 1.h,
                          children: _dateRangeOptions.map((range) {
                            final isSelected =
                                (_filters['dateRange'] as String?) == range;
                            return FilterChip(
                              label: Text(range),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _filters['dateRange'] =
                                      selected ? range : 'All Time';
                                  if (range != 'Custom Range') {
                                    _startDate = null;
                                    _endDate = null;
                                  }
                                });
                              },
                              backgroundColor: AppTheme.darkTheme.cardColor,
                              selectedColor:
                                  AppTheme.accentColor.withValues(alpha: 0.2),
                              labelStyle: AppTheme.darkTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.accentColor
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? AppTheme.accentColor
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: 1,
                              ),
                            );
                          }).toList(),
                        ),
                        if ((_filters['dateRange'] as String?) ==
                            'Custom Range') ...[
                          SizedBox(height: 2.h),
                          OutlinedButton.icon(
                            onPressed: _selectDateRange,
                            icon: CustomIconWidget(
                              iconName: 'date_range',
                              color: AppTheme.accentColor,
                              size: 20,
                            ),
                            label: Text(
                              _startDate != null && _endDate != null
                                  ? '${_startDate!.month}/${_startDate!.day}/${_startDate!.year} - ${_endDate!.month}/${_endDate!.day}/${_endDate!.year}'
                                  : 'Select Date Range',
                              style: AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.accentColor,
                              side: BorderSide(color: AppTheme.accentColor),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Customer Filter
                  _buildFilterSection(
                    title: 'Customer Name',
                    child: TextField(
                      controller: _customerController,
                      style: AppTheme.darkTheme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Enter customer name',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Amount Range Filter
                  _buildFilterSection(
                    title: 'Amount Range',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minAmountController,
                            keyboardType: TextInputType.number,
                            style: AppTheme.darkTheme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Min amount',
                              prefixText: '\$ ',
                              prefixStyle:
                                  AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'to',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: TextField(
                            controller: _maxAmountController,
                            keyboardType: TextInputType.number,
                            style: AppTheme.darkTheme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              hintText: 'Max amount',
                              prefixText: '\$ ',
                              prefixStyle:
                                  AppTheme.darkTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.cardColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearAllFilters,
                    child: Text('Clear All'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }
}
