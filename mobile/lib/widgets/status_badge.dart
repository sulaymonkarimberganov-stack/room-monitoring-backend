import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  Color _getColor() {
    switch (status.toUpperCase()) {
      case 'CLEAN':
        return AppTheme.cleanGreen;
      case 'DIRTY':
        return AppTheme.dirtyRed;
      case 'OCCUPIED':
        return AppTheme.occupiedBlue;
      case 'CLEANING':
      case 'IN_PROGRESS':
        return AppTheme.cleaningYellow;
      case 'MAINTENANCE':
        return AppTheme.maintenanceOrange;
      default:
        return Colors.grey;
    }
  }
  
  Color _getBgColor() {
    switch (status.toUpperCase()) {
      case 'CLEAN':
        return AppTheme.cleanBgGreen;
      case 'DIRTY':
        return AppTheme.dirtyBgRed;
      case 'OCCUPIED':
        return AppTheme.occupiedBgBlue;
      case 'CLEANING':
      case 'IN_PROGRESS':
        return AppTheme.cleaningBgYellow;
      case 'MAINTENANCE':
        return AppTheme.maintenanceOrange.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
  
  Color _getBorderColor() {
    switch (status.toUpperCase()) {
      case 'CLEAN':
        return AppTheme.cleanBorderGreen;
      case 'DIRTY':
        return AppTheme.dirtyBorderRed;
      case 'OCCUPIED':
        return AppTheme.occupiedBorderBlue;
      case 'CLEANING':
      case 'IN_PROGRESS':
        return AppTheme.cleaningBorderYellow;
      case 'MAINTENANCE':
        return AppTheme.maintenanceOrange;
      default:
        return Colors.grey;
    }
  }

  String _getText() {
    switch (status.toUpperCase()) {
      case 'CLEAN':
        return 'Toza';
      case 'DIRTY':
        return 'Iflos';
      case 'OCCUPIED':
        return 'Band';
      case 'MAINTENANCE':
        return 'Ta\'mirlash';
      case 'IN_PROGRESS':
        return 'Tozalanmoqda';
      case 'PENDING':
        return 'Kutilmoqda';
      case 'COMPLETED':
        return 'Bajarildi';
      case 'CANCELLED':
        return 'Bekor qilindi';
      default:
        return status;
    }
  }

  IconData _getIcon() {
    switch (status.toUpperCase()) {
      case 'CLEAN':
        return Icons.check_circle;
      case 'DIRTY':
        return Icons.warning;
      case 'OCCUPIED':
        return Icons.person;
      case 'MAINTENANCE':
        return Icons.build;
      case 'IN_PROGRESS':
        return Icons.cleaning_services;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final bgColor = _getBgColor();
    final borderColor = _getBorderColor();

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            _getText(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
