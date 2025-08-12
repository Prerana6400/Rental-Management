import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_section.dart';
import './widgets/customer_info_card.dart';
import './widgets/order_items_section.dart';
import './widgets/pricing_breakdown_card.dart';
import './widgets/status_timeline_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Mock order data
  final Map<String, dynamic> orderData = {
    "orderId": "ORD-2025-001247",
    "orderNumber": "#001247",
    "status": "Shipped",
    "orderDate": DateTime(2025, 1, 8, 14, 30),
    "customer": {
      "name": "Sarah Johnson",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "address":
          "1234 Oak Street, Apartment 5B\nSan Francisco, CA 94102\nUnited States"
    },
    "items": [
      {
        "id": 1,
        "name": "Professional Camera Kit",
        "description":
            "High-quality DSLR camera with lens kit, perfect for professional photography and videography projects.",
        "image":
            "https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=400&h=400&fit=crop",
        "quantity": 2,
        "price": 450.00
      },
      {
        "id": 2,
        "name": "Lighting Equipment Set",
        "description":
            "Complete studio lighting setup with softboxes, stands, and LED panels for professional shoots.",
        "image":
            "https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400&h=400&fit=crop",
        "quantity": 1,
        "price": 280.00
      },
      {
        "id": 3,
        "name": "Audio Recording System",
        "description":
            "Professional microphone and audio interface for high-quality sound recording.",
        "image":
            "https://images.unsplash.com/photo-1590602847861-f357a9332bbc?w=400&h=400&fit=crop",
        "quantity": 1,
        "price": 320.00
      }
    ],
    "pricing": {
      "subtotal": 1500.00,
      "tax": 120.00,
      "discount": 75.00,
      "shipping": 25.00,
      "total": 1570.00,
      "paymentMethod": "Credit Card (**** 4532)"
    },
    "statusHistory": [
      {
        "status": "Pending",
        "timestamp": DateTime(2025, 1, 8, 14, 30),
        "description": "Order received and awaiting confirmation"
      },
      {
        "status": "Confirmed",
        "timestamp": DateTime(2025, 1, 8, 16, 45),
        "description": "Order confirmed and payment processed"
      },
      {
        "status": "Shipped",
        "timestamp": DateTime(2025, 1, 9, 10, 15),
        "description": "Package shipped via FedEx - Tracking: 1234567890123456"
      }
    ],
    "trackingNumber": "FedEx: 1234567890123456"
  };

  late String currentStatus;
  late List<Map<String, dynamic>> orderItems;
  late List<Map<String, dynamic>> statusHistory;

  @override
  void initState() {
    super.initState();
    currentStatus = orderData['status'] as String;
    orderItems = List<Map<String, dynamic>>.from(orderData['items'] as List);
    statusHistory =
        List<Map<String, dynamic>>.from(orderData['statusHistory'] as List);
  }

  void _updateOrderStatus(String newStatus) {
    setState(() {
      currentStatus = newStatus;
      statusHistory.add({
        "status": newStatus,
        "timestamp": DateTime.now(),
        "description": "Status updated by admin"
      });
    });
  }

  void _updateTracking(String trackingInfo) {
    setState(() {
      orderData['trackingNumber'] = trackingInfo;
    });
  }

  void _sendInvoice() {
    Fluttertoast.showToast(
      msg: 'Invoice sent to ${orderData['customer']['email']}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareOrder() {
    final orderSummary = '''
Order Details - ${orderData['orderNumber']}

Customer: ${orderData['customer']['name']}
Status: $currentStatus
Total: \$${(orderData['pricing']['total'] as double).toStringAsFixed(2)}

Items:
${orderItems.map((item) => '• ${item['name']} (Qty: ${item['quantity']}) - \$${(item['price'] as double).toStringAsFixed(2)}').join('\n')}

Order Date: ${(orderData['orderDate'] as DateTime).day}/${(orderData['orderDate'] as DateTime).month}/${(orderData['orderDate'] as DateTime).year}
''';

    Share.share(orderSummary,
        subject: 'Order ${orderData['orderNumber']} Details');
  }

  void _updateItemQuantity(int index, int newQuantity) {
    setState(() {
      orderItems[index]['quantity'] = newQuantity;
      _recalculatePricing();
    });
  }

  void _updateItemPrice(int index, double newPrice) {
    setState(() {
      orderItems[index]['price'] = newPrice;
      _recalculatePricing();
    });
  }

  void _recalculatePricing() {
    double subtotal = 0;
    for (var item in orderItems) {
      subtotal += (item['quantity'] as int) * (item['price'] as double);
    }

    final tax = subtotal * 0.08; // 8% tax
    final discount = orderData['pricing']['discount'] as double;
    final shipping = orderData['pricing']['shipping'] as double;
    final total = subtotal + tax - discount + shipping;

    setState(() {
      orderData['pricing']['subtotal'] = subtotal;
      orderData['pricing']['tax'] = tax;
      orderData['pricing']['total'] = total;
    });
  }

  void _showMoreActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 10.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'print',
                  color: AppTheme.accentColor,
                  size: 24,
                ),
                title: Text(
                  'Print Order',
                  style: AppTheme.darkTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Print functionality would be implemented here',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.accentColor,
                  size: 24,
                ),
                title: Text(
                  'Download PDF',
                  style: AppTheme.darkTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'PDF download would be implemented here',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.accentColor,
                  size: 24,
                ),
                title: Text(
                  'Edit Order',
                  style: AppTheme.darkTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Edit order functionality would be implemented here',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 1.h,
              left: 4.w,
              right: 4.w,
              bottom: 2.h,
            ),
            decoration: BoxDecoration(
              color: AppTheme.darkTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.darkTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Details',
                        style:
                            AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        orderData['orderNumber'] as String,
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _showMoreActions,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.darkTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.darkTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  CustomerInfoCard(
                    customerData: orderData['customer'] as Map<String, dynamic>,
                  ),
                  OrderItemsSection(
                    orderItems: orderItems,
                    onQuantityChanged: _updateItemQuantity,
                    onPriceChanged: _updateItemPrice,
                  ),
                  PricingBreakdownCard(
                    pricingData: orderData['pricing'] as Map<String, dynamic>,
                  ),
                  StatusTimelineWidget(
                    statusHistory: statusHistory,
                    currentStatus: currentStatus,
                  ),
                  SizedBox(height: 10.h), // Space for floating action buttons
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: ActionButtonsSection(
        currentStatus: currentStatus,
        onStatusUpdate: _updateOrderStatus,
        onTrackingUpdate: _updateTracking,
        onSendInvoice: _sendInvoice,
        onShareOrder: _shareOrder,
      ),
    );
  }
}
