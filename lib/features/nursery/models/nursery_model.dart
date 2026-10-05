import '../../marketplace/models/plant_model.dart';

class Nursery {

  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String coverUrl;
  final double rating;
  final int reviewCount;
  final int productCount;
  final bool verified;
  final bool premium;
  final String description;

  const Nursery({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.coverUrl,
    required this.rating,
    required this.reviewCount,
    required this.productCount,
    required this.verified,
    required this.premium,
    required this.description,
  });
}

/// Backwards compatibility alias
typedef MockNursery = Nursery;

class NurseryInventoryItem {
  final Plant plant;
  int stock;
  bool isArchived;

  NurseryInventoryItem({
    required this.plant,
    required this.stock,
    this.isArchived = false,
  });

  bool get isLowStock => stock > 0 && stock <= 5;
  bool get isOutOfStock => stock <= 0;
}

