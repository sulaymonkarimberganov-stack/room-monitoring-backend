import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Android emulator uchun 10.0.2.2, haqiqiy telefon uchun kompyuter IP si
  static const String baseUrl = 'https://room-monitoring-backend-production.up.railway.app/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── AUTH ───────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return jsonDecode(res.body);
  }

  // ─── ROOMS ──────────────────────────────────────────────
  static Future<List<dynamic>> getRooms() async {
    final res = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateRoomStatus(
      int roomId, String status) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/rooms/$roomId/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(res.body);
  }

  // ─── TASKS ──────────────────────────────────────────────
  static Future<List<dynamic>> getMyTasks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tasks/my'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getAllTasks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateTaskStatus(
      int taskId, String status) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/tasks/$taskId/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(res.body);
  }

  // ─── INVENTORY ──────────────────────────────────────────
  static Future<List<dynamic>> getLowStock() async {
    final res = await http.get(
      Uri.parse('$baseUrl/inventory/low-stock'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }
}
