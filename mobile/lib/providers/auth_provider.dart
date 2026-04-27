import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _username;
  String? _role;

  bool get isLoggedIn => _token != null;
  String? get username => _username;
  String? get role => _role;
  bool get isAdmin => _role == 'ADMIN';
  bool get isManager => _role == 'MANAGER' || _role == 'ADMIN';

  AuthProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _username = prefs.getString('username');
    _role = prefs.getString('role');
    notifyListeners();
  }

  Future<String?> login(String username, String password) async {
    try {
      final data = await ApiService.login(username, password);
      if (data['token'] != null) {
        _token = data['token'];
        _username = data['username'];
        _role = data['role'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('username', _username!);
        await prefs.setString('role', _role!);
        notifyListeners();
        return null;
      }
      return data['message'] ?? 'Xatolik yuz berdi';
    } catch (e) {
      return 'Server bilan ulanib bo\'lmadi';
    }
  }

  Future<void> logout() async {
    _token = null;
    _username = null;
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
