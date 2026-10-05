import '../../marketplace/models/plant_model.dart';

class CartItem {
  final Plant plant;
  int quantity;
  final String? potOption; // e.g. 'মাটির টব', 'সিরামিক টব', 'নার্সারি পলিব্যাগ'

  CartItem({
    required this.plant,
    this.quantity = 1,
    this.potOption = 'নার্সারি পলিব্যাগ',
  });

  double get totalPrice => plant.price * quantity;
}

enum DeliveryZone {
  insideDhaka,
  outsideDhaka,
  expressSameDay,
}

extension DeliveryZoneExtension on DeliveryZone {
  String get labelBn {
    switch (this) {
      case DeliveryZone.insideDhaka:
        return 'ঢাকা মেট্রো (২-৩ দিন)';
      case DeliveryZone.outsideDhaka:
        return 'ঢাকার বাইরে (৩-৫ দিন)';
      case DeliveryZone.expressSameDay:
        return 'এক্সপ্রেস ডেলিভারি (একই দিন)';
    }
  }

  double get charge {
    switch (this) {
      case DeliveryZone.insideDhaka:
        return 80.0;
      case DeliveryZone.outsideDhaka:
        return 150.0;
      case DeliveryZone.expressSameDay:
        return 180.0;
    }
  }
}
