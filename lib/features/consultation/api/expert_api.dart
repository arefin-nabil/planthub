import '../../../data/mock/mock_data.dart';
import '../models/expert_model.dart';

/// Handles Plant Expert directory and consultation bookings
class ExpertApi {
  Future<List<Expert>> getExperts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(MockData.experts);
  }

  Future<Expert?> getExpertById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return MockData.experts.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
