/// Plant Model representing a botanical product in the marketplace
class Plant {
  final String id;
  final String name;
  final String nameBn;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String nurseryName;
  final bool nurseryVerified;
  final bool nurseryPremium;
  final double rating;
  final int reviewCount;
  final int sold;
  final String category;
  final bool inWishlist;
  final String careLevel;
  final String sunlight;
  final String water;

  const Plant({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.nurseryName,
    this.nurseryVerified = false,
    this.nurseryPremium = false,
    required this.rating,
    required this.reviewCount,
    required this.sold,
    required this.category,
    this.inWishlist = false,
    required this.careLevel,
    required this.sunlight,
    required this.water,
  });

  Plant copyWith({
    String? id,
    String? name,
    String? nameBn,
    String? imageUrl,
    double? price,
    double? originalPrice,
    String? nurseryName,
    bool? nurseryVerified,
    bool? nurseryPremium,
    double? rating,
    int? reviewCount,
    int? sold,
    String? category,
    bool? inWishlist,
    String? careLevel,
    String? sunlight,
    String? water,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      nurseryName: nurseryName ?? this.nurseryName,
      nurseryVerified: nurseryVerified ?? this.nurseryVerified,
      nurseryPremium: nurseryPremium ?? this.nurseryPremium,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      sold: sold ?? this.sold,
      category: category ?? this.category,
      inWishlist: inWishlist ?? this.inWishlist,
      careLevel: careLevel ?? this.careLevel,
      sunlight: sunlight ?? this.sunlight,
      water: water ?? this.water,
    );
  }
}

/// Backwards compatibility alias
typedef MockPlant = Plant;
