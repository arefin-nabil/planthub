import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/plant_model.dart';
import '../../../data/mock/mock_data.dart';

class WishlistProvider extends ChangeNotifier {
  final Map<String, Plant> _wishlistMap = {};

  WishlistProvider() {
    // Seed initial wishlisted items from MockData
    for (final plant in MockData.plants) {
      if (plant.inWishlist) {
        _wishlistMap[plant.id] = plant;
      }
    }
  }

  // Getters
  List<Plant> get items => _wishlistMap.values.toList();
  int get count => _wishlistMap.length;
  bool get isEmpty => _wishlistMap.isEmpty;

  bool isWishlisted(String plantId) => _wishlistMap.containsKey(plantId);

  // Actions
  void toggleWishlist(Plant plant) {
    if (_wishlistMap.containsKey(plant.id)) {
      _wishlistMap.remove(plant.id);
    } else {
      _wishlistMap[plant.id] = plant;
    }
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  void addToWishlist(Plant plant) {
    if (!_wishlistMap.containsKey(plant.id)) {
      _wishlistMap[plant.id] = plant;
      notifyListeners();
    }
  }

  void removeFromWishlist(String plantId) {
    if (_wishlistMap.containsKey(plantId)) {
      _wishlistMap.remove(plantId);
      notifyListeners();
    }
  }

  void clearWishlist() {
    _wishlistMap.clear();
    notifyListeners();
  }
}
