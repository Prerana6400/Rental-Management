import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_sheet_detail_widget.dart';
import './widgets/chart_carousel_widget.dart';
import './widgets/kpi_card_widget.dart';
import './widgets/time_filter_widget.dart';
import './widgets/top_products_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedBottomNavIndex = 0;
  String _selectedTimeFilter = 'Week';
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  final List<Map<String, dynamic>> kpiData = [
    {
      "title": "Total Sales",
      "value": "\$128,500",
      "growth": "+12.5",
      "isPositive": true,
    },
    {
      "title": "Active Users",
      "value": "6,332",
      "growth": "+8.2",
      "isPositive": true,
    },
    {
      "title": "Total Orders",
      "value": "556",
      "growth": "-2.1",
      "isPositive": false,
    },
    {
      "title": "Revenue Growth",
      "value": "15.8%",
      "growth": "+5.3",
      "isPositive": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _refreshController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    _refreshController.reset();
    if (mounted) {
      setState(() {
        // Simulate data refresh
      });
    }
  }

  void _showKpiDetails(Map<String, dynamic> kpi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetDetailWidget(
        title: kpi["title"],
        value: kpi["value"],
        growthPercentage: kpi["growth"],
        isPositiveGrowth: kpi["isPositive"],
      ),
    );
  }

  void _onTimeFilterChanged(String filter) {
    setState(() {
      _selectedTimeFilter = filter;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/orders-management-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/products-management-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.accentColor,
          backgroundColor: AppTheme.darkTheme.cardColor,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildTimeFilter(),
              _buildKpiCards(),
              _buildChartsSection(),
              _buildTopProductsSection(),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 12.h,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentColor,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome back,',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      'Admin Dashboard',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle notifications
                    },
                    icon: CustomIconWidget(
                      iconName: 'notifications_outlined',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          TimeFilterWidget(
            onFilterChanged: _onTimeFilterChanged,
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Widget _buildKpiCards() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.3,
          ),
          itemCount: kpiData.length,
          itemBuilder: (context, index) {
            final kpi = kpiData[index];
            return AnimatedBuilder(
              animation: _refreshAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 - (_refreshAnimation.value * 0.05),
                  child: KpiCardWidget(
                    title: kpi["title"],
                    value: kpi["value"],
                    growthPercentage: kpi["growth"],
                    isPositiveGrowth: kpi["isPositive"],
                    onLongPress: () => _showKpiDetails(kpi),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Analytics Overview',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          const ChartCarouselWidget(),
        ],
      ),
    );
  }

  Widget _buildTopProductsSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 4.h),
          const TopProductsWidget(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.textSecondary,
        selectedLabelStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.bodySmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _selectedBottomNavIndex == 0
                  ? 'dashboard'
                  : 'dashboard_outlined',
              color: _selectedBottomNavIndex == 0
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _selectedBottomNavIndex == 1
                  ? 'receipt_long'
                  : 'receipt_long_outlined',
              color: _selectedBottomNavIndex == 1
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _selectedBottomNavIndex == 2
                  ? 'inventory'
                  : 'inventory_2_outlined',
              color: _selectedBottomNavIndex == 2
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName:
                  _selectedBottomNavIndex == 3 ? 'person' : 'person_outline',
              color: _selectedBottomNavIndex == 3
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _showQuickActionsBottomSheet();
      },
      backgroundColor: AppTheme.accentColor,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.primaryDark,
        size: 28,
      ),
    );
  }

  void _showQuickActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            Text(
              'Quick Actions',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  icon: 'add_shopping_cart',
                  label: 'Add Product',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/products-management-screen');
                  },
                ),
                _buildQuickActionButton(
                  icon: 'receipt_long',
                  label: 'New Order',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orders-management-screen');
                  },
                ),
                _buildQuickActionButton(
                  icon: 'analytics',
                  label: 'Reports',
                  onTap: () {
                    Navigator.pop(context);
                    // Handle reports action
                  },
                ),
              ],
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.accentColor,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
