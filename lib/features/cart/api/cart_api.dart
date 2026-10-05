import '../models/cart_item_model.dart';

/// Handles Cart operations and checkout validation
class CartApi {
  static const Map<String, double> validCoupons = {
    'SOBUJ20': 0.20,
    'FIRSTPLANT': 0.15,
    'DHAKA50': 50.0,
  };

  Future<double?> validateCoupon(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final upper = code.trim().toUpperCase();
    return validCoupons[upper];
  }

  double calculateDelivery(DeliveryZone zone) {
    return zone.charge;
  }
}
