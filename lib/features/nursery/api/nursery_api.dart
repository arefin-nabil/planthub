import '../../../data/mock/mock_data.dart';
import '../models/nursery_model.dart';

/// Handles Nursery data and dashboard stats
class NurseryApi {
  Future<List<Nursery>> getNurseries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(MockData.nurseries);
  }

  Future<Nursery?> getNurseryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return MockData.nurseries.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.nurseryDashboardStats;
  }
}
