import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:ua/feature/login/domain/entities/user.dart' as domain;

class UserModel extends domain.User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.address,
    required super.role,
    super.createdAt,
  });

  factory UserModel.fromFirebase(fb.User user, {domain.UserRole? role}) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber,
      address: null,
      role: role ?? domain.UserRole.customer,
      createdAt: user.metadata.creationTime,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: _roleFromString(json['role'] as String?),
      createdAt: (json['createdAt'] as String?) != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role.name,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    domain.UserRole? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static domain.UserRole _roleFromString(String? value) {
    switch (value) {
      case 'admin':
        return domain.UserRole.admin;
      case 'customer':
      default:
        return domain.UserRole.customer;
    }
  }
}
