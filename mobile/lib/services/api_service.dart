import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Render.com backend URL (Railway o'rniga)
  // TODO: Render deploy bo'lgandan keyin bu URL ni yangilang
  static const String baseUrl = 'https://YOUR-RENDER-URL.onrender.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── AUTH ───────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final res = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get current user');
  }

  // ─── ROOMS ──────────────────────────────────────────────
  Future<List<dynamic>> getRooms() async {
    final res = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateRoomStatus(int roomId, String status) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/rooms/$roomId/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getRoomPhotos(int roomId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/rooms/$roomId/photos'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get room photos: ${res.statusCode}');
  }

  // ─── TASKS ──────────────────────────────────────────────
  Future<List<dynamic>> getMyTasks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tasks/my'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getAllTasks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateTaskStatus(int taskId, String status) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/tasks/$taskId/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status}),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> uploadTaskPhoto(int taskId, String filePath) async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl/tasks/$taskId/photo');
    
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    
    // Add photo file with proper content type
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        filePath,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload photo: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<dynamic>> getPendingApprovalTasks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tasks/pending-approval'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get pending approval tasks');
  }

  Future<Map<String, dynamic>> approveTask(int taskId) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/tasks/$taskId/approve'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to approve task');
  }

  // ─── INVENTORY ──────────────────────────────────────────
  Future<List<dynamic>> getInventory() async {
    final res = await http.get(
      Uri.parse('$baseUrl/inventory'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getLowStock() async {
    final res = await http.get(
      Uri.parse('$baseUrl/inventory/low-stock'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> requestInventoryRefill(int itemId, int quantity, String comment) async {
    final res = await http.post(
      Uri.parse('$baseUrl/inventory/$itemId/request'),
      headers: await _headers(),
      body: jsonEncode({
        'quantity': quantity,
        'comment': comment.isNotEmpty ? comment : null,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to request inventory refill: ${res.statusCode}');
  }

  // ─── USERS / STAFF ──────────────────────────────────────
  Future<List<dynamic>> getStaff() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users?role=STAFF'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get staff: ${res.statusCode}');
  }

  Future<List<dynamic>> getUserRooms(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/$userId/rooms'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get user rooms: ${res.statusCode}');
  }

  // ─── MANAGER ────────────────────────────────────────────
  Future<Map<String, dynamic>> getManagerOverview() async {
    final res = await http.get(
      Uri.parse('$baseUrl/manager/overview'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get manager overview: ${res.statusCode}');
  }

  // ─── STATISTICS ─────────────────────────────────────────
  Future<Map<String, dynamic>> getWeeklyStatistics() async {
    final res = await http.get(
      Uri.parse('$baseUrl/statistics/weekly'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get weekly statistics');
  }

  Future<Map<String, dynamic>> getStatisticsSummary({int? period}) async {
    final periodParam = period != null ? '?period=$period' : '';
    final res = await http.get(
      Uri.parse('$baseUrl/statistics/summary$periodParam'),
      headers: await _headers(),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Failed to get statistics summary');
  }
  
  // Calculate statistics from existing data (fallback)
  Future<Map<String, dynamic>> calculateStatistics({int days = 7}) async {
    try {
      // Get all rooms and tasks
      final rooms = await getRooms();
      final tasks = await getAllTasks();
      
      // Calculate date range
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));
      
      // Count cleaned rooms in period
      int cleanedCount = 0;
      int totalTasks = 0;
      int completedOnTime = 0;
      List<int> avgTimes = [];
      
      for (var task in tasks) {
        if (task['completedAt'] != null) {
          try {
            final completedAt = DateTime.parse(task['completedAt']);
            if (completedAt.isAfter(startDate)) {
              cleanedCount++;
              totalTasks++;
              
              // Calculate time taken (if createdAt exists)
              if (task['createdAt'] != null) {
                final createdAt = DateTime.parse(task['createdAt']);
                final duration = completedAt.difference(createdAt);
                avgTimes.add(duration.inMinutes);
                
                // Check if completed on time (assume 30 min is standard)
                if (duration.inMinutes <= 30) {
                  completedOnTime++;
                }
              }
            }
          } catch (e) {
            // Skip invalid dates
          }
        }
      }
      
      // Calculate metrics
      final efficiency = totalTasks > 0 ? (completedOnTime / totalTasks * 100) : 0.0;
      final avgTime = avgTimes.isNotEmpty 
          ? avgTimes.reduce((a, b) => a + b) / avgTimes.length 
          : 0.0;
      
      // Generate weekly data
      List<Map<String, dynamic>> weeklyData = [];
      final dayNames = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
      
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayStart = DateTime(date.year, date.month, date.day);
        final dayEnd = dayStart.add(const Duration(days: 1));
        
        int dayCount = 0;
        for (var task in tasks) {
          if (task['completedAt'] != null) {
            try {
              final completedAt = DateTime.parse(task['completedAt']);
              if (completedAt.isAfter(dayStart) && completedAt.isBefore(dayEnd)) {
                dayCount++;
              }
            } catch (e) {
              // Skip
            }
          }
        }
        
        weeklyData.add({
          'day': dayNames[date.weekday - 1],
          'count': dayCount,
          'date': date.toIso8601String(),
        });
      }
      
      return {
        'totalCleaned': cleanedCount,
        'efficiency': efficiency,
        'avgTime': avgTime,
        'weeklyData': weeklyData,
        'period': days,
      };
    } catch (e) {
      throw Exception('Failed to calculate statistics: $e');
    }
  }

  // ─── FCM ────────────────────────────────────────────────
  Future<void> sendFCMToken(String token) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/users/fcm-token'),
        headers: await _headers(),
        body: jsonEncode({'fcmToken': token}),
      );
      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception('Failed to send FCM token: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending FCM token: $e');
    }
  }
}
