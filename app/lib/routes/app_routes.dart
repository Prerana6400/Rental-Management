import 'package:flutter/material.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/product_details_screen/product_details_screen.dart';
import '../presentation/products_management_screen/products_management_screen.dart';
import '../presentation/orders_management_screen/orders_management_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/order_details_screen/order_details_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String dashboard = '/dashboard-screen';
  static const String productDetails = '/product-details-screen';
  static const String productsManagement = '/products-management-screen';
  static const String ordersManagement = '/orders-management-screen';
  static const String profile = '/profile-screen';
  static const String orderDetails = '/order-details-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardScreen(),
    dashboard: (context) => const DashboardScreen(),
    productDetails: (context) => const ProductDetailsScreen(),
    productsManagement: (context) => const ProductsManagementScreen(),
    ordersManagement: (context) => const OrdersManagementScreen(),
    profile: (context) => const ProfileScreen(),
    orderDetails: (context) => const OrderDetailsScreen(),
    // TODO: Add your other routes here
  };
}
