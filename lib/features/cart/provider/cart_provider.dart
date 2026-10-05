import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../marketplace/models/plant_model.dart';
import '../models/cart_item_model.dart';
import '../../../data/mock/mock_data.dart';

export '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  DeliveryZone _deliveryZone = DeliveryZone.insideDhaka;
  String _couponCode = '';
  double _discountAmount = 0.0;
  String? _couponError;

  CartProvider() {
    // Seed with 2 initial mock items for realistic preview
    if (MockData.plants.length >= 2) {
      _items[MockData.plants[0].id] = CartItem(plant: MockData.plants[0], quantity: 1);
      _items[MockData.plants[1].id] = CartItem(plant: MockData.plants[1], quantity: 2);
    }
  }

  // Getters
  Map<String, CartItem> get items => Map.unmodifiable(_items);
  List<CartItem> get itemList => _items.values.toList();
  int get uniqueItemCount => _items.length;
  int get totalItemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  DeliveryZone get deliveryZone => _deliveryZone;
  String get couponCode => _couponCode;
  double get discountAmount => _discountAmount;
  String? get couponError => _couponError;

  double get subtotal => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryCharge {
    if (_items.isEmpty) return 0.0;
    // Free delivery on orders over ৳2,000 in Dhaka
    if (subtotal >= 2000 && _deliveryZone == DeliveryZone.insideDhaka) {
      return 0.0;
    }
    return _deliveryZone.charge;
  }

  double get grandTotal {
    final rawTotal = (subtotal - _discountAmount) + deliveryCharge;
    return rawTotal > 0 ? rawTotal : 0.0;
  }

  // Actions
  void addItem(Plant plant, {int quantity = 1, String? potOption}) {
    if (_items.containsKey(plant.id)) {
      _items[plant.id]!.quantity += quantity;
    } else {
      _items[plant.id] = CartItem(
        plant: plant,
        quantity: quantity,
        potOption: potOption ?? 'নার্সারি পলিব্যাগ',
      );
    }
    _recalculateCoupon();
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void updateQuantity(String plantId, int newQuantity) {
    if (!_items.containsKey(plantId)) return;
    if (newQuantity <= 0) {
      _items.remove(plantId);
    } else {
      _items[plantId]!.quantity = newQuantity;
    }
    _recalculateCoupon();
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void removeItem(String plantId) {
    _items.remove(plantId);
    _recalculateCoupon();
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _couponCode = '';
    _discountAmount = 0.0;
    _couponError = null;
    notifyListeners();
  }

  void setDeliveryZone(DeliveryZone zone) {
    _deliveryZone = zone;
    notifyListeners();
  }

  bool applyCoupon(String code) {
    final cleanCode = code.trim().toUpperCase();
    _couponError = null;

    if (cleanCode == 'GREEN20') {
      _couponCode = 'GREEN20';
      _discountAmount = subtotal * 0.20; // 20% off
      notifyListeners();
      return true;
    } else if (cleanCode == 'PLANT100') {
      _couponCode = 'PLANT100';
      _discountAmount = 100.0; // ৳100 flat discount
      notifyListeners();
      return true;
    } else {
      _couponError = 'কুপন কোডটি সঠিক নয় বা মেয়াদ শেষ।';
      notifyListeners();
      return false;
    }
  }

  void removeCoupon() {
    _couponCode = '';
    _discountAmount = 0.0;
    _couponError = null;
    notifyListeners();
  }

  void _recalculateCoupon() {
    if (_couponCode == 'GREEN20') {
      _discountAmount = subtotal * 0.20;
    } else if (_couponCode == 'PLANT100') {
      _discountAmount = 100.0 > subtotal ? subtotal : 100.0;
    }
  }
}
