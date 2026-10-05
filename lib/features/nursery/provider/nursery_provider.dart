import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/nursery_model.dart';
import '../../../data/mock/mock_data.dart';


export '../models/nursery_model.dart';

class NurseryProvider extends ChangeNotifier {
  final List<NurseryInventoryItem> _inventory = [];
  String _inventorySearch = '';

  NurseryProvider() {
    // Populate with mock items and realistic stock counts
    int count = 15;
    for (final plant in MockData.plants) {
      _inventory.add(NurseryInventoryItem(
        plant: plant,
        stock: count,
      ));
      count = (count + 7) % 25; // variety of stock levels
    }
    // ensure at least one is low stock and one is out of stock for realistic dashboard
    if (_inventory.isNotEmpty) _inventory[0].stock = 3; // low stock
    if (_inventory.length > 2) _inventory[2].stock = 0; // out of stock
  }

  // Getters
  List<NurseryInventoryItem> get inventory => List.unmodifiable(_inventory);
  String get inventorySearch => _inventorySearch;

  List<NurseryInventoryItem> get filteredInventory {
    if (_inventorySearch.isEmpty) return _inventory;
    final query = _inventorySearch.toLowerCase();
    return _inventory.where((item) {
      return item.plant.name.toLowerCase().contains(query) ||
          item.plant.nameBn.contains(query);
    }).toList();
  }

  int get totalProducts => _inventory.where((i) => !i.isArchived).length;
  int get lowStockCount => _inventory.where((i) => i.isLowStock && !i.isArchived).length;
  int get outOfStockCount => _inventory.where((i) => i.isOutOfStock && !i.isArchived).length;

  double get todaySales => 14850.0;
  int get todayOrders => 12;
  double get monthlyRevenue => 184500.0;

  // Actions
  void setInventorySearch(String query) {
    _inventorySearch = query;
    notifyListeners();
  }

  void updateStock(String plantId, int delta) {
    final idx = _inventory.indexWhere((item) => item.plant.id == plantId);
    if (idx != -1) {
      final current = _inventory[idx].stock;
      final updated = (current + delta).clamp(0, 9999);
      _inventory[idx].stock = updated;
      HapticFeedback.selectionClick();
      notifyListeners();
    }
  }

  void setStock(String plantId, int exactStock) {
    final idx = _inventory.indexWhere((item) => item.plant.id == plantId);
    if (idx != -1) {
      _inventory[idx].stock = exactStock.clamp(0, 9999);
      HapticFeedback.lightImpact();
      notifyListeners();
    }
  }

  void toggleArchive(String plantId) {
    final idx = _inventory.indexWhere((item) => item.plant.id == plantId);
    if (idx != -1) {
      _inventory[idx].isArchived = !_inventory[idx].isArchived;
      HapticFeedback.mediumImpact();
      notifyListeners();
    }
  }
}
