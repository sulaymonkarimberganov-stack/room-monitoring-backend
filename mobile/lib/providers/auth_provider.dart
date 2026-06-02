import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/api_service.dart';
import '../services/fcm_service.dart';
import '../models/user_role.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  UserModel? _currentUser;
  bool _isLoading = false;

  bool get isLoggedIn => _token != null && _currentUser != null;
  String? get username => _currentUser?.username;
  UserRole? get role => _currentUser?.role;
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Role checks
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isManager => _currentUser?.isManager ?? false;
  bool get isCleaner => _currentUser?.isCleaner ?? false;

  // Permission checks
  bool get canManageUsers => _currentUser?.role.canManageUsers ?? false;
  bool get canViewReports => _currentUser?.role.canViewReports ?? false;
  bool get canViewAllRooms => _currentUser?.role.canViewAllRooms ?? false;

  AuthProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');

      if (_token != null) {
        // Check if token is expired
        if (JwtDecoder.isExpired(_token!)) {
          await logout();
          return;
        }

        // Decode token to get user info
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
        
        // Try to get full user info from backend
        try {
          final api = ApiService();
          final userData = await api.getCurrentUser();
          _currentUser = UserModel.fromJson(userData);
        } catch (e) {
          // Fallback to token data if API call fails
          _currentUser = UserModel(
            id: decodedToken['userId'] ?? 0,
            username: decodedToken['sub'] ?? '',
            role: UserRole.fromString(decodedToken['role'] ?? 'CLEANER'),
            status: 'ACTIVE',
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading auth data: $e');
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Clear any existing auth data before login
      _token = null;
      _currentUser = null;
      
      // Clear old auth data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('userId');
      await prefs.remove('username');
      await prefs.remove('role');
      await prefs.remove('work_history');

      final api = ApiService();
      final data = await api.login(username, password);

      if (data['token'] != null) {
        _token = data['token'];

        // Decode JWT token
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);

        // Get user info from token or response
        _currentUser = UserModel(
          id: data['id'] ?? decodedToken['userId'] ?? 0,
          username: data['username'] ?? decodedToken['sub'] ?? username,
          role: UserRole.fromString(data['role'] ?? decodedToken['role'] ?? 'CLEANER'),
          status: data['status'] ?? 'ACTIVE',
          fullName: data['fullName'],
          email: data['email'],
        );

        // Save to SharedPreferences
        await prefs.setString('token', _token!);
        await prefs.setString('userId', _currentUser!.id.toString());
        await prefs.setString('username', _currentUser!.username);
        await prefs.setString('role', _currentUser!.role.value);

        // Subscribe to FCM topics based on role
        try {
          final fcmService = FCMService();
          await fcmService.subscribeToRoleTopics(_currentUser!.role.value);
        } catch (e) {
          debugPrint('FCM subscription error: $e');
        }

        _isLoading = false;
        notifyListeners();
        return null;
      }

      _isLoading = false;
      notifyListeners();
      return data['message'] ?? 'Xatolik yuz berdi';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Login error: $e');
      return 'Server bilan ulanib bo\'lmadi';
    }
  }

  Future<void> logout() async {
    try {
      // Unsubscribe from FCM topics
      final fcmService = FCMService();
      await fcmService.unsubscribeFromAllTopics();
    } catch (e) {
      debugPrint('FCM unsubscribe error: $e');
    }
    
    // Clear all data
    _token = null;
    _currentUser = null;
    _isLoading = false;
    
    // Clear only auth-related SharedPreferences (keep theme and other settings)
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('role');
    
    // Clear work history (staff specific data)
    await prefs.remove('work_history');
    
    notifyListeners();
  }
  
  // Reset state (for logout)
  void reset() {
    _token = null;
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  UserRole getCurrentUserRole() {
    return _currentUser?.role ?? UserRole.cleaner;
  }

  String getRoleDisplayName() {
    return _currentUser?.role.displayName ?? 'Foydalanuvchi';
  }

  // Get token expiry time
  DateTime? getTokenExpiryDate() {
    if (_token == null) return null;
    try {
      return JwtDecoder.getExpirationDate(_token!);
    } catch (e) {
      return null;
    }
  }

  // Check if token will expire soon (within 1 hour)
  bool isTokenExpiringSoon() {
    final expiryDate = getTokenExpiryDate();
    if (expiryDate == null) return true;
    final now = DateTime.now();
    final difference = expiryDate.difference(now);
    return difference.inHours < 1;
  }
}
