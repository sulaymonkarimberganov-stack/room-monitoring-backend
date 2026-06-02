import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingWidget extends StatelessWidget {
  final String? message;
  final double size;
  final bool showLottie;

  const CustomLoadingWidget({
    super.key,
    this.message,
    this.size = 60,
    this.showLottie = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading animation
          if (showLottie)
            // Lottie animation (agar asset mavjud bo'lsa)
            SizedBox(
              width: size * 2,
              height: size * 2,
              child: Lottie.asset(
                'assets/animations/loading.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Agar Lottie fayl topilmasa, default loading ko'rsatamiz
                  return _buildDefaultLoading();
                },
              ),
            )
          else
            _buildDefaultLoading(),

          const SizedBox(height: 24),

          // Loading text
          Text(
            message ?? 'Yuklanmoqda...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLoading() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1565C0).withOpacity(value),
                  const Color(0xFF5E35B1).withOpacity(1 - value),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.3 * value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop animation
      },
    );
  }
}

/// Kichik loading indicator (button ichida ishlatish uchun)
class SmallLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const SmallLoadingIndicator({
    super.key,
    this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}

/// Overlay loading (butun ekranni qoplash uchun)
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    this.message,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: CustomLoadingWidget(message: message),
          ),
      ],
    );
  }
}
