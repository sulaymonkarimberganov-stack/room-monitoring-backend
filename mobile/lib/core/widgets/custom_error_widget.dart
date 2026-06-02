import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const CustomErrorWidget({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon with animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEF5350).withOpacity(0.15),
                      border: Border.all(
                        color: const Color(0xFFEF5350).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon ?? Icons.error_outline,
                      size: 50,
                      color: const Color(0xFFEF5350),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Error title
            Text(
              title ?? 'Xatolik yuz berdi',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Error message
            Text(
              message ?? 'Nimadir noto\'g\'ri ketdi. Iltimos, qayta urinib ko\'ring.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Retry button
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Qayta urinish'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Network error widget
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Internet aloqasi yo\'q',
      message: 'Iltimos, internet aloqangizni tekshiring va qayta urinib ko\'ring.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

/// Server error widget
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? errorMessage;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      title: 'Server xatosi',
      message: errorMessage ?? 'Server bilan bog\'lanishda xatolik yuz berdi. Iltimos, keyinroq urinib ko\'ring.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }
}
