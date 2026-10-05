import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../api/login_auth_api.dart';

export '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final LoginAuthApi _authApi = LoginAuthApi();

  UserRole _activeRole = UserRole.customer;
  bool _isAuthenticated = true; // demo initial state
  bool _isLoading = false;

  UserProfile _user = const UserProfile(
    id: 'USR-8821',
    name: 'রাহেলা বেগম',
    email: 'rahela@planthub.bd',
    phone: '+880 1712-345678',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80',
    address: 'বাড়ি ৫, রোড ৮, ধানমন্ডি, ঢাকা ১২০৫',
    nurseryName: 'গ্রিন প্যারাডাইস নার্সারি',
    expertSpecialty: 'অর্গানিক পেস্ট ম্যানেজমেন্ট ও ইনডোর কেয়ার',
  );

  // Getters
  UserRole get activeRole => _activeRole;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  UserProfile get user => _user;

  bool get isCustomer => _activeRole == UserRole.customer;
  bool get isNurseryOwner => _activeRole == UserRole.nurseryOwner;
  bool get isExpert => _activeRole == UserRole.expert;
  bool get isAdmin => _activeRole == UserRole.admin;

  void switchRole(UserRole newRole) {
    if (_activeRole == newRole) return;
    _activeRole = newRole;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void updateProfile({String? name, String? phone, String? address}) {
    _user = _user.copyWith(name: name, phone: phone, address: address);
    notifyListeners();
  }

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authApi.login(email: email, password: password, role: _activeRole);
      _isAuthenticated = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authApi.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: _activeRole,
      );
      _user = _user.copyWith(name: name, email: email, phone: phone);
      _isAuthenticated = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authApi.logout();
    _isAuthenticated = false;
    _activeRole = UserRole.customer;
    notifyListeners();
  }
}
