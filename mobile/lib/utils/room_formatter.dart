/// Utility class for formatting room numbers
class RoomFormatter {
  /// Format room number for display
  /// Examples:
  /// - "1" → "1-xona"
  /// - "101" → "1-xona" (legacy format)
  /// - "10" → "10-xona"
  static String format(dynamic roomNumber) {
    if (roomNumber == null) return 'N/A';
    
    final String roomStr = roomNumber.toString();
    final int? num = int.tryParse(roomStr);
    
    if (num == null) return '$roomStr-xona';
    
    // Handle legacy format (101-110 → 1-10)
    if (num >= 101 && num <= 110) {
      return '${num - 100}-xona';
    }
    
    // Handle new format (1-10)
    return '$num-xona';
  }
  
  /// Get just the room number without "-xona" suffix
  static String getNumber(dynamic roomNumber) {
    if (roomNumber == null) return 'N/A';
    
    final String roomStr = roomNumber.toString();
    final int? num = int.tryParse(roomStr);
    
    if (num == null) return roomStr;
    
    // Handle legacy format (101-110 → 1-10)
    if (num >= 101 && num <= 110) {
      return '${num - 100}';
    }
    
    // Handle new format (1-10)
    return num.toString();
  }
}
