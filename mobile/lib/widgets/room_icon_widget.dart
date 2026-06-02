import 'package:flutter/material.dart';

class RoomIconWidget extends StatelessWidget {
  final String roomType;
  final String status;
  final double size;

  const RoomIconWidget({
    super.key,
    required this.roomType,
    required this.status,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconForRoomType(roomType);
    final colors = _getColorsForRoomTypeAndStatus(roomType, status);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors['border']!,
          width: 1.5,
        ),
      ),
      child: Icon(
        iconData,
        color: colors['icon'],
        size: size * 0.5,
      ),
    );
  }

  IconData _getIconForRoomType(String type) {
    final normalizedType = type.toUpperCase();
    
    switch (normalizedType) {
      case 'STANDARD':
        return Icons.home_outlined;
      case 'LUXURY':
        return Icons.menu_book_outlined;
      case 'SUITE':
        return Icons.star_outline;
      case 'MAINTENANCE':
        return Icons.build_outlined;
      default:
        return Icons.home_outlined;
    }
  }

  Map<String, Color> _getColorsForRoomTypeAndStatus(String type, String roomStatus) {
    final normalizedStatus = roomStatus.toUpperCase();
    
    // Status-based colors (to'yinroq ranglar)
    if (normalizedStatus == 'CLEAN') {
      return {
        'background': const Color(0xFF4CAF50),  // To'yinroq yashil
        'border': const Color(0xFF2E7D32),
        'icon': Colors.white,
      };
    } else if (normalizedStatus == 'DIRTY') {
      return {
        'background': const Color(0xFFEF5350),  // To'yinroq qizil
        'border': const Color(0xFFC62828),
        'icon': Colors.white,
      };
    } else if (normalizedStatus == 'CLEANING' || normalizedStatus == 'IN_PROGRESS') {
      return {
        'background': const Color(0xFFFF6D00),  // To'yinroq to'q sariq
        'border': const Color(0xFFE65100),
        'icon': Colors.white,
      };
    } else if (normalizedStatus == 'OCCUPIED') {
      return {
        'background': const Color(0xFF1976D2),  // To'yinroq ko'k
        'border': const Color(0xFF1565C0),
        'icon': Colors.white,
      };
    }

    // Default fallback
    return {
      'background': const Color(0xFF9E9E9E),
      'border': const Color(0xFF757575),
      'icon': Colors.white,
    };
  }
}
