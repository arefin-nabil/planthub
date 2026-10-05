import 'package:flutter/material.dart';

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

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = UserRole.customer,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.customer,
      ),
      avatarUrl: map['avatarUrl'],
    );
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

