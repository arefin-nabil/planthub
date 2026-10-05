import '../../../data/mock/mock_data.dart';
import '../models/plant_model.dart';

/// Handles Plant & Marketplace API requests
class PlantApi {
  // TODO: Replace MockData with real database/REST endpoint
  Future<List<Plant>> getPlants() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(MockData.plants);
  }

  Future<Plant?> getPlantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return MockData.plants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Plant>> searchPlants(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final q = query.toLowerCase();
    return MockData.plants.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.nameBn.contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.nurseryName.toLowerCase().contains(q);
    }).toList();
  }

  Future<List<Map<String, String>>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockData.banners;
  }
}
