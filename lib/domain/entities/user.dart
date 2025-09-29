import 'package:equatable/equatable.dart';

enum UserRole {
  customer,
  admin,
}

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final UserRole role;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, phone, address, role, createdAt];
}