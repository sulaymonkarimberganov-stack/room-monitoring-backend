enum UserRole {
  admin('ADMIN'),
  manager('MANAGER'),
  cleaner('CLEANER');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;
      case 'MANAGER':
        return UserRole.manager;
      case 'CLEANER':
        return UserRole.cleaner;
      default:
        return UserRole.cleaner;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.manager:
        return 'Menejer';
      case UserRole.cleaner:
        return 'Tozalovchi';
    }
  }

  bool get canManageUsers => this == UserRole.admin;
  bool get canViewReports => this == UserRole.admin || this == UserRole.manager;
  bool get canViewAllRooms => this == UserRole.admin || this == UserRole.manager;
  bool get canEditRoomStatus => true; // Barcha rollar xona holatini o'zgartira oladi
}
