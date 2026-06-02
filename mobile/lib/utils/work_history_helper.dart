import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WorkHistoryHelper {
  static const String _historyKey = 'work_history';

  static Future<void> saveToHistory({
    required String imagePath,
    required String roomId,
    required String roomName,
    required DateTime time,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_historyKey) ?? [];
      
      final entry = jsonEncode({
        'imagePath': imagePath,
        'roomId': roomId,
        'roomName': roomName,
        'time': time.toIso8601String(),
      });
      
      history.insert(0, entry); // Add to beginning (newest first)
      
      // Keep only last 100 entries
      if (history.length > 100) {
        history.removeRange(100, history.length);
      }
      
      await prefs.setStringList(_historyKey, history);
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_historyKey) ?? [];
      
      return history.map((entry) {
        try {
          return jsonDecode(entry) as Map<String, dynamic>;
        } catch (e) {
          return <String, dynamic>{};
        }
      }).where((entry) => entry.isNotEmpty).toList();
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }

  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  static Future<int> getHistoryCount() async {
    final history = await getHistory();
    return history.length;
  }
}
