import '../models/user_model.dart';

/// Handles authentication API requests (Login, Register, Session)
class LoginAuthApi {
  // TODO: Replace with real Firebase / Supabase / REST API call
  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 600));

    return UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      phone: '+880 1700 000000',
      role: role,
    );
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
