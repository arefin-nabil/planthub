import 'package:flutter/material.dart';
import '../models/plant_model.dart';
import '../api/plant_api.dart';
import '../../../data/mock/mock_data.dart';

enum PlantSortBy {
  popular,
  priceLowToHigh,
  priceHighToLow,
  rating,
}

extension PlantSortByExtension on PlantSortBy {
  String get labelBn {
    switch (this) {
      case PlantSortBy.popular:
        return 'সবচেয়ে জনপ্রিয়';
      case PlantSortBy.priceLowToHigh:
        return 'দাম: কম থেকে বেশি';
      case PlantSortBy.priceHighToLow:
        return 'দাম: বেশি থেকে কম';
      case PlantSortBy.rating:
        return 'সর্বোচ্চ রেটিং';
    }
  }
}

class MarketplaceProvider extends ChangeNotifier {
  final PlantApi _plantApi = PlantApi();

  List<Plant> _allPlants = [];
  String _searchQuery = '';
  String _selectedCategory = 'সব';
  String _selectedSunlight = 'সব';
  String _selectedWater = 'সব';
  String _selectedCareLevel = 'সব';
  bool _verifiedOnly = false;
  RangeValues _priceRange = const RangeValues(0, 5000);
  PlantSortBy _sortBy = PlantSortBy.popular;
  bool _isLoading = false;

  // Predefined Categories
  static const List<String> categories = [
    'সব',
    'ইনডোর',
    'আউটডোর ও ফুল',
    'ফলজ ও ঔষধি',
    'সাকুলেন্ট ও বনসাই',
    'টব ও প্ল্যান্টার',
    'মাটি ও জৈব সার',
  ];

  static const List<String> sunlightOptions = [
    'সব',
    'ছায়াযুক্ত/ইনডোর',
    'উজ্জ্বল পরোক্ষ আলো',
    'সরাসরি রোদ',
  ];

  static const List<String> waterOptions = [
    'সব',
    'সপ্তাহে ১ বার',
    'সপ্তাহে ২-৩ বার',
    'প্রতিদিন',
  ];

  static const List<String> careLevelOptions = [
    'সব',
    'সহজ (Beginner)',
    'মাঝারি (Moderate)',
    'অভিজ্ঞ (Advanced)',
  ];

  MarketplaceProvider() {
    _allPlants = List.from(MockData.plants);
  }

  // Getters
  List<Plant> get allPlants => List.unmodifiable(_allPlants);
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedSunlight => _selectedSunlight;
  String get selectedWater => _selectedWater;
  String get selectedCareLevel => _selectedCareLevel;
  bool get verifiedOnly => _verifiedOnly;
  RangeValues get priceRange => _priceRange;
  PlantSortBy get sortBy => _sortBy;

  int get activeFilterCount {
    int count = 0;
    if (_selectedCategory != 'সব') count++;
    if (_selectedSunlight != 'সব') count++;
    if (_selectedWater != 'সব') count++;
    if (_selectedCareLevel != 'সব') count++;
    if (_verifiedOnly) count++;
    if (_priceRange.start > 0 || _priceRange.end < 5000) count++;
    return count;
  }

  List<Plant> get filteredPlants {
    var result = _allPlants.where((plant) {
      // Search
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = plant.name.toLowerCase().contains(query);
        final matchBn = plant.nameBn.contains(query);
        final matchNursery = plant.nurseryName.toLowerCase().contains(query);
        final matchCategory = plant.category.toLowerCase().contains(query);
        if (!matchName && !matchBn && !matchNursery && !matchCategory) {
          return false;
        }
      }

      // Category
      if (_selectedCategory != 'সব') {
        if (_selectedCategory == 'ইনডোর' && !plant.category.contains('ইনডোর')) return false;
        if (_selectedCategory == 'আউটডোর ও ফুল' && (!plant.category.contains('আউটডোর') && !plant.category.contains('ফুল'))) return false;
        if (_selectedCategory == 'ফলজ ও ঔষধি' && (!plant.category.contains('ফল') && !plant.category.contains('ঔষধি'))) return false;
        if (_selectedCategory == 'সাকুলেন্ট ও বনসাই' && (!plant.category.contains('সাকুলেন্ট') && !plant.category.contains('বনসাই'))) return false;
        if (_selectedCategory == 'টব ও প্ল্যান্টার' && !plant.category.contains('টব')) return false;
        if (_selectedCategory == 'মাটি ও জৈব সার' && !plant.category.contains('সার')) return false;
      }

      // Sunlight
      if (_selectedSunlight != 'সব') {
        if (_selectedSunlight.contains('ছায়া') && !plant.sunlight.contains('ছায়া') && !plant.sunlight.contains('কম আলো')) return false;
        if (_selectedSunlight.contains('পরোক্ষ') && !plant.sunlight.contains('পরোক্ষ')) return false;
        if (_selectedSunlight.contains('সরাসরি') && !plant.sunlight.contains('রোদ') && !plant.sunlight.contains('সরাসরি')) return false;
      }

      // Water
      if (_selectedWater != 'সব') {
        if (_selectedWater.contains('১ বার') && !plant.water.contains('একবার') && !plant.water.contains('১ বার')) return false;
        if (_selectedWater.contains('২-৩ বার') && !plant.water.contains('দুইবার') && !plant.water.contains('২-৩')) return false;
        if (_selectedWater.contains('প্রতিদিন') && !plant.water.contains('প্রতিদিন')) return false;
      }

      // Care level
      if (_selectedCareLevel != 'সব') {
        if (_selectedCareLevel.contains('সহজ') && !plant.careLevel.contains('সহজ')) return false;
        if (_selectedCareLevel.contains('মাঝারি') && !plant.careLevel.contains('মাঝারি')) return false;
        if (_selectedCareLevel.contains('অভিজ্ঞ') && !plant.careLevel.contains('অভিজ্ঞ')) return false;
      }

      // Verified only
      if (_verifiedOnly && !plant.nurseryVerified) {
        return false;
      }

      // Price range
      if (plant.price < _priceRange.start || plant.price > _priceRange.end) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    switch (_sortBy) {
      case PlantSortBy.popular:
        result.sort((a, b) => b.sold.compareTo(a.sold));
        break;
      case PlantSortBy.priceLowToHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case PlantSortBy.priceHighToLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case PlantSortBy.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return result;
  }

  // Filter setters
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSunlight(String sunlight) {
    _selectedSunlight = sunlight;
    notifyListeners();
  }

  void setWater(String water) {
    _selectedWater = water;
    notifyListeners();
  }

  void setCareLevel(String careLevel) {
    _selectedCareLevel = careLevel;
    notifyListeners();
  }

  void toggleVerifiedOnly() {
    _verifiedOnly = !_verifiedOnly;
    notifyListeners();
  }

  void setPriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  void setSortBy(PlantSortBy sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = 'সব';
    _selectedSunlight = 'সব';
    _selectedWater = 'সব';
    _selectedCareLevel = 'সব';
    _verifiedOnly = false;
    _priceRange = const RangeValues(0, 5000);
    _sortBy = PlantSortBy.popular;
    notifyListeners();
  }

  // Product mutation actions
  void addProduct(Plant plant) {
    _allPlants.insert(0, plant);
    notifyListeners();
  }

  void updateProduct(Plant plant) {
    final idx = _allPlants.indexWhere((p) => p.id == plant.id);
    if (idx != -1) {
      _allPlants[idx] = plant;
      notifyListeners();
    }
  }

  void deleteProduct(String plantId) {
    _allPlants.removeWhere((p) => p.id == plantId);
    notifyListeners();
  }
}
