import 'user_role.dart';

class UserModel {
  final int id;
  final String username;
  final UserRole role;
  final String status;
  final String? fullName;
  final String? email;

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.status,
    this.fullName,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'CLEANER'),
      status: json['status'] ?? 'ACTIVE',
      fullName: json['fullName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role.value,
      'status': status,
      'fullName': fullName,
      'email': email,
    };
  }

  bool get isActive => status.toUpperCase() == 'ACTIVE';
  bool get isAdmin => role == UserRole.admin;
  bool get isManager => role == UserRole.manager;
  bool get isCleaner => role == UserRole.cleaner;
}
