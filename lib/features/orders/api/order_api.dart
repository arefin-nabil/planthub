import '../../../data/mock/mock_data.dart';
import '../models/order_model.dart';

/// Handles Order creation, listing, and tracking requests
class OrderApi {
  Future<List<Order>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(MockData.orders);
  }

  Future<Order?> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return MockData.orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }
}
