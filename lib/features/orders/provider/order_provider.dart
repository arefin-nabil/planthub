import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order_model.dart';
import '../../cart/models/cart_item_model.dart';
import '../../../data/mock/mock_data.dart';

export '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  OrderProvider() {
    _orders.addAll(MockData.orders);
  }

  List<Order> get orders => List.unmodifiable(_orders);
  int get activeOrderCount => _orders.where((o) => o.status != 'Delivered' && o.status != 'Cancelled').length;

  Order? placeOrder({
    required List<CartItem> cartItems,
    required double totalAmount,
    required String paymentMethod,
    required String address,
    required String phone,
  }) {
    if (cartItems.isEmpty) return null;

    final firstItem = cartItems.first;
    final totalQty = cartItems.fold(0, (sum, item) => sum + item.quantity);
    final orderId = 'ORD-${DateTime.now().year}-${(_orders.length + 101).toString()}';

    final orderTitle = cartItems.length == 1
        ? firstItem.plant.nameBn
        : '${firstItem.plant.nameBn} + ${cartItems.length - 1}টি অন্য গাছ';

    final newOrder = Order(
      id: orderId,
      plantName: orderTitle,
      plantImage: firstItem.plant.imageUrl,
      quantity: totalQty,
      total: totalAmount,
      status: 'Pending',
      nurseryName: firstItem.plant.nurseryName,
      date: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    HapticFeedback.heavyImpact();
    notifyListeners();
    return newOrder;
  }

  void cancelOrder(String orderId) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final old = _orders[idx];
      _orders[idx] = Order(
        id: old.id,
        plantName: old.plantName,
        plantImage: old.plantImage,
        quantity: old.quantity,
        total: old.total,
        status: 'Cancelled',
        nurseryName: old.nurseryName,
        date: old.date,
      );
      HapticFeedback.mediumImpact();
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final old = _orders[idx];
      _orders[idx] = Order(
        id: old.id,
        plantName: old.plantName,
        plantImage: old.plantImage,
        quantity: old.quantity,
        total: old.total,
        status: newStatus,
        nurseryName: old.nurseryName,
        date: old.date,
      );
      HapticFeedback.lightImpact();
      notifyListeners();
    }
  }

  void advanceOrderStatus(String orderId) {
    const statuses = ['Pending', 'Confirmed', 'Packed', 'Shipped', 'Delivered'];
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final current = _orders[idx].status;
      final currentIdx = statuses.indexOf(current);
      if (currentIdx != -1 && currentIdx < statuses.length - 1) {
        updateOrderStatus(orderId, statuses[currentIdx + 1]);
      }
    }
  }
}
