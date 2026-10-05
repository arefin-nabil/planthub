import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum UserRole {
  customer,
  nurseryOwner,
  expert,
  admin,
}

extension UserRoleExtension on UserRole {
  String get titleEn {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.nurseryOwner:
        return 'Nursery Owner';
      case UserRole.expert:
        return 'Plant Expert';
      case UserRole.admin:
        return 'Admin';
    }
  }

  String get titleBn {
    switch (this) {
      case UserRole.customer:
        return 'কাস্টমার';
      case UserRole.nurseryOwner:
        return 'নার্সারি ওনার';
      case UserRole.expert:
        return 'প্ল্যান্ট এক্সপার্ট';
      case UserRole.admin:
        return 'অ্যাডমিন';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.customer:
        return Icons.person_rounded;
      case UserRole.nurseryOwner:
        return Icons.storefront_rounded;
      case UserRole.expert:
        return Icons.medical_services_rounded;
      case UserRole.admin:
        return Icons.admin_panel_settings_rounded;
    }
  }

  Color get color {
    switch (this) {
      case UserRole.customer:
        return const Color(0xFF2E7D32);
      case UserRole.nurseryOwner:
        return const Color(0xFF1B5E20);
      case UserRole.expert:
        return const Color(0xFF00897B);
      case UserRole.admin:
        return const Color(0xFF5E35B1);
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String address;
  final String? nurseryName;
  final String? expertSpecialty;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.address,
    this.nurseryName,
    this.expertSpecialty,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? address,
    String? nurseryName,
    String? expertSpecialty,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      nurseryName: nurseryName ?? this.nurseryName,
      expertSpecialty: expertSpecialty ?? this.expertSpecialty,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  UserRole _activeRole = UserRole.customer;
  bool _isAuthenticated = true; // demo initial state

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

  void login({required String email, required String password}) {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _activeRole = UserRole.customer;
    notifyListeners();
  }
}
