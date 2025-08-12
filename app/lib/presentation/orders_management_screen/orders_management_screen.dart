import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/order_card_widget.dart';

class OrdersManagementScreen extends StatefulWidget {
  const OrdersManagementScreen({Key? key}) : super(key: key);

  @override
  State<OrdersManagementScreen> createState() => _OrdersManagementScreenState();
}

class _OrdersManagementScreenState extends State<OrdersManagementScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> _currentFilters = {
    'status': 'All',
    'dateRange': 'All Time',
    'customer': '',
    'minAmount': null,
    'maxAmount': null,
    'startDate': null,
    'endDate': null,
  };

  List<Map<String, dynamic>> _filteredOrders = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  int _currentNavIndex = 1; // Orders tab active

  // Mock orders data
  final List<Map<String, dynamic>> _allOrders = [
    {
      "id": 1,
      "orderNumber": "ORD-2024-001",
      "customerName": "Sarah Johnson",
      "customerEmail": "sarah.johnson@email.com",
      "customerPhone": "+1 (555) 123-4567",
      "totalAmount": 1250.00,
      "status": "confirmed",
      "orderDate": DateTime.now().subtract(const Duration(hours: 2)),
      "items": [
        {"name": "Premium Office Chair", "quantity": 2, "price": 450.00},
        {"name": "Standing Desk", "quantity": 1, "price": 350.00}
      ],
      "trackingNumber": "TRK123456789",
    },
    {
      "id": 2,
      "orderNumber": "ORD-2024-002",
      "customerName": "Michael Rodriguez",
      "customerEmail": "michael.rodriguez@email.com",
      "customerPhone": "+1 (555) 987-6543",
      "totalAmount": 875.50,
      "status": "pending",
      "orderDate": DateTime.now().subtract(const Duration(hours: 5)),
      "items": [
        {"name": "Conference Table", "quantity": 1, "price": 875.50}
      ],
      "trackingNumber": null,
    },
    {
      "id": 3,
      "orderNumber": "ORD-2024-003",
      "customerName": "Emily Chen",
      "customerEmail": "emily.chen@email.com",
      "customerPhone": "+1 (555) 456-7890",
      "totalAmount": 2100.00,
      "status": "shipped",
      "orderDate": DateTime.now().subtract(const Duration(days: 1)),
      "items": [
        {"name": "Executive Desk Set", "quantity": 1, "price": 1200.00},
        {"name": "Ergonomic Chair", "quantity": 2, "price": 450.00}
      ],
      "trackingNumber": "TRK987654321",
    },
    {
      "id": 4,
      "orderNumber": "ORD-2024-004",
      "customerName": "David Thompson",
      "customerEmail": "david.thompson@email.com",
      "customerPhone": "+1 (555) 321-0987",
      "totalAmount": 650.00,
      "status": "delivered",
      "orderDate": DateTime.now().subtract(const Duration(days: 3)),
      "items": [
        {"name": "Meeting Room Chairs", "quantity": 4, "price": 162.50}
      ],
      "trackingNumber": "TRK456789123",
    },
    {
      "id": 5,
      "orderNumber": "ORD-2024-005",
      "customerName": "Lisa Anderson",
      "customerEmail": "lisa.anderson@email.com",
      "customerPhone": "+1 (555) 654-3210",
      "totalAmount": 1800.00,
      "status": "canceled",
      "orderDate": DateTime.now().subtract(const Duration(days: 2)),
      "items": [
        {"name": "Reception Desk", "quantity": 1, "price": 1800.00}
      ],
      "trackingNumber": null,
    },
    {
      "id": 6,
      "orderNumber": "ORD-2024-006",
      "customerName": "James Wilson",
      "customerEmail": "james.wilson@email.com",
      "customerPhone": "+1 (555) 789-0123",
      "totalAmount": 950.00,
      "status": "confirmed",
      "orderDate": DateTime.now().subtract(const Duration(hours: 8)),
      "items": [
        {"name": "Bookshelf Unit", "quantity": 2, "price": 475.00}
      ],
      "trackingNumber": "TRK789012345",
    },
    {
      "id": 7,
      "orderNumber": "ORD-2024-007",
      "customerName": "Maria Garcia",
      "customerEmail": "maria.garcia@email.com",
      "customerPhone": "+1 (555) 012-3456",
      "totalAmount": 1350.75,
      "status": "pending",
      "orderDate": DateTime.now().subtract(const Duration(hours: 12)),
      "items": [
        {"name": "L-Shaped Desk", "quantity": 1, "price": 750.00},
        {"name": "Office Storage Cabinet", "quantity": 1, "price": 600.75}
      ],
      "trackingNumber": null,
    },
    {
      "id": 8,
      "orderNumber": "ORD-2024-008",
      "customerName": "Robert Brown",
      "customerEmail": "robert.brown@email.com",
      "customerPhone": "+1 (555) 345-6789",
      "totalAmount": 725.00,
      "status": "shipped",
      "orderDate": DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      "items": [
        {"name": "Adjustable Monitor Stand", "quantity": 3, "price": 125.00},
        {"name": "Wireless Charging Pad", "quantity": 5, "price": 65.00}
      ],
      "trackingNumber": "TRK345678901",
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_allOrders);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 300), () {
      List<Map<String, dynamic>> filtered = List.from(_allOrders);

      // Search filter
      final searchQuery = _searchController.text.toLowerCase().trim();
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((order) {
          final customerName = (order['customerName'] as String).toLowerCase();
          final orderNumber = (order['orderNumber'] as String).toLowerCase();
          return customerName.contains(searchQuery) ||
              orderNumber.contains(searchQuery);
        }).toList();
      }

      // Status filter
      final statusFilter = _currentFilters['status'] as String?;
      if (statusFilter != null && statusFilter != 'All') {
        filtered = filtered
            .where((order) =>
                (order['status'] as String).toLowerCase() ==
                statusFilter.toLowerCase())
            .toList();
      }

      // Customer filter
      final customerFilter =
          (_currentFilters['customer'] as String?)?.toLowerCase().trim();
      if (customerFilter?.isNotEmpty == true) {
        filtered = filtered
            .where((order) => (order['customerName'] as String)
                .toLowerCase()
                .contains(customerFilter!))
            .toList();
      }

      // Amount range filter
      final minAmount = _currentFilters['minAmount'] as double?;
      final maxAmount = _currentFilters['maxAmount'] as double?;
      if (minAmount != null || maxAmount != null) {
        filtered = filtered.where((order) {
          final amount = (order['totalAmount'] as num).toDouble();
          if (minAmount != null && amount < minAmount) return false;
          if (maxAmount != null && amount > maxAmount) return false;
          return true;
        }).toList();
      }

      // Date range filter
      final dateRange = _currentFilters['dateRange'] as String?;
      final startDate = _currentFilters['startDate'] as DateTime?;
      final endDate = _currentFilters['endDate'] as DateTime?;

      if (dateRange != null && dateRange != 'All Time') {
        final now = DateTime.now();
        DateTime? filterStartDate;
        DateTime? filterEndDate;

        switch (dateRange) {
          case 'Today':
            filterStartDate = DateTime(now.year, now.month, now.day);
            filterEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
            break;
          case 'This Week':
            final weekday = now.weekday;
            filterStartDate = now.subtract(Duration(days: weekday - 1));
            filterStartDate = DateTime(filterStartDate.year,
                filterStartDate.month, filterStartDate.day);
            filterEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
            break;
          case 'This Month':
            filterStartDate = DateTime(now.year, now.month, 1);
            filterEndDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
            break;
          case 'Last 30 Days':
            filterStartDate = now.subtract(const Duration(days: 30));
            filterEndDate = now;
            break;
          case 'Custom Range':
            filterStartDate = startDate;
            filterEndDate = endDate;
            break;
        }

        if (filterStartDate != null && filterEndDate != null) {
          filtered = filtered.where((order) {
            final orderDate = order['orderDate'] as DateTime;
            return orderDate.isAfter(filterStartDate!) &&
                orderDate.isBefore(filterEndDate!);
          }).toList();
        }
      }

      // Sort by date (newest first)
      filtered.sort((a, b) =>
          (b['orderDate'] as DateTime).compareTo(a['orderDate'] as DateTime));

      setState(() {
        _filteredOrders = filtered;
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _filteredOrders = List.from(_allOrders);
      _isRefreshing = false;
    });

    _applyFilters();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _navigateToOrderDetails(Map<String, dynamic> order) {
    Navigator.pushNamed(
      context,
      '/order-details-screen',
      arguments: order,
    );
  }

  void _updateOrderStatus(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
        title: Text(
          'Update Order Status',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order #${order['orderNumber']}',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            DropdownButtonFormField<String>(
              value: order['status'] as String,
              decoration: InputDecoration(
                labelText: 'Status',
                labelStyle: AppTheme.darkTheme.textTheme.bodyMedium,
              ),
              dropdownColor: AppTheme.darkTheme.cardColor,
              style: AppTheme.darkTheme.textTheme.bodyMedium,
              items:
                  ['pending', 'confirmed', 'shipped', 'delivered', 'canceled']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.toUpperCase()),
                          ))
                      .toList(),
              onChanged: (newStatus) {
                if (newStatus != null) {
                  setState(() {
                    order['status'] = newStatus;
                    final index =
                        _allOrders.indexWhere((o) => o['id'] == order['id']);
                    if (index != -1) {
                      _allOrders[index]['status'] = newStatus;
                    }
                  });
                  Navigator.pop(context);
                  _applyFilters();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Order status updated to ${newStatus.toUpperCase()}'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  void _trackOrder(Map<String, dynamic> order) {
    final trackingNumber = order['trackingNumber'] as String?;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.dialogBackgroundColor,
        title: Text(
          'Track Order',
          style: AppTheme.darkTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order['orderNumber']}',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            if (trackingNumber != null) ...[
              Text(
                'Tracking Number:',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.darkTheme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.accentColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  trackingNumber,
                  style: AppTheme.dataTextStyle(
                    isLight: false,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: AppTheme.accentColor),
                ),
              ),
            ] else ...[
              Text(
                'No tracking number assigned yet.',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.warningColor,
                ),
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () {
                  final newTrackingNumber =
                      'TRK${DateTime.now().millisecondsSinceEpoch}';
                  setState(() {
                    order['trackingNumber'] = newTrackingNumber;
                    final index =
                        _allOrders.indexWhere((o) => o['id'] == order['id']);
                    if (index != -1) {
                      _allOrders[index]['trackingNumber'] = newTrackingNumber;
                    }
                  });
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Tracking number assigned: $newTrackingNumber'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
                child: Text('Assign Tracking Number'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteOrder(Map<String, dynamic> order) {
    setState(() {
      _allOrders.removeWhere((o) => o['id'] == order['id']);
      _filteredOrders.removeWhere((o) => o['id'] == order['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #${order['orderNumber']} deleted'),
        backgroundColor: AppTheme.errorColor,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _allOrders.add(order);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _navigateToScreen(int index) {
    if (index == _currentNavIndex) return;

    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
        break;
      case 1:
        // Already on orders screen
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/products-management-screen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile-screen');
        break;
    }
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if ((_currentFilters['status'] as String?) != null &&
        (_currentFilters['status'] as String?) != 'All') count++;
    if ((_currentFilters['dateRange'] as String?) != null &&
        (_currentFilters['dateRange'] as String?) != 'All Time') count++;
    if ((_currentFilters['customer'] as String?)?.isNotEmpty == true) count++;
    if ((_currentFilters['minAmount'] as double?) != null ||
        (_currentFilters['maxAmount'] as double?) != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filter
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.darkTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkTheme.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Orders Management',
                        style: AppTheme.darkTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_getActiveFiltersCount() > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_getActiveFiltersCount()} filters',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: AppTheme.darkTheme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Search orders or customers...',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'search',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _applyFilters();
                                    },
                                    icon: CustomIconWidget(
                                      iconName: 'clear',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.accentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: IconButton(
                          onPressed: _showFilterModal,
                          icon: CustomIconWidget(
                            iconName: 'filter_list',
                            color: AppTheme.accentColor,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Orders List
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.accentColor,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshOrders,
                      color: AppTheme.accentColor,
                      backgroundColor: AppTheme.darkTheme.cardColor,
                      child: _filteredOrders.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 2.h),
                              itemCount: _filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = _filteredOrders[index];
                                return OrderCardWidget(
                                  orderData: order,
                                  onTap: () => _navigateToOrderDetails(order),
                                  onViewDetails: () =>
                                      _navigateToOrderDetails(order),
                                  onUpdateStatus: () =>
                                      _updateOrderStatus(order),
                                  onTrack: () => _trackOrder(order),
                                  onDelete: () => _deleteOrder(order),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to create new order screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Create new order functionality coming soon'),
              backgroundColor: AppTheme.accentColor,
            ),
          );
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.darkTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'New Order',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.accentColor,
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentNavIndex,
        onTap: _navigateToScreen,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Orders Found',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchController.text.isNotEmpty || _getActiveFiltersCount() > 0
                  ? 'Try adjusting your search or filters'
                  : 'Orders will appear here when customers place them',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (_searchController.text.isNotEmpty ||
                _getActiveFiltersCount() > 0)
              OutlinedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _currentFilters = {
                      'status': 'All',
                      'dateRange': 'All Time',
                      'customer': '',
                      'minAmount': null,
                      'maxAmount': null,
                      'startDate': null,
                      'endDate': null,
                    };
                  });
                  _applyFilters();
                },
                child: Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }
}
