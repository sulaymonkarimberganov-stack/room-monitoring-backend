import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const primaryBlue = Color(0xFF2196F3);
  static const primaryPurple = Color(0xFF9C27B0);
  static const darkBlue = Color(0xFF0D47A1);
  static const lightBlue = Color(0xFF42A5F5);
  
  // Status Colors - TO'YIN VA YORQIN
  static const cleanGreen = Color(0xFF2E7D32);        // To'q yashil
  static const cleaningYellow = Color(0xFFE65100);    // To'q to'q sariq
  static const dirtyRed = Color(0xFFC62828);          // To'q qizil
  static const occupiedBlue = Color(0xFF1565C0);      // Ko'k
  static const maintenanceOrange = Color(0xFFFF6F00);
  
  // Status Background Colors (card background)
  static const cleanBgGreen = Color(0xFF1B5E20);      // Qo'yu yashil fon
  static const cleaningBgYellow = Color(0xFFBF360C);  // Qo'yu to'q sariq fon
  static const dirtyBgRed = Color(0xFFB71C1C);        // Qo'yu qizil fon
  static const occupiedBgBlue = Color(0xFF0D47A1);    // Qo'yu ko'k fon
  
  // Status Border Colors
  static const cleanBorderGreen = Color(0xFF4CAF50);
  static const cleaningBorderYellow = Color(0xFFFF6D00);
  static const dirtyBorderRed = Color(0xFFEF5350);
  static const occupiedBorderBlue = Color(0xFF1976D2);
  
  // Gradients
  static const loginGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryPurple],
  );
  
  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryBlue, primaryPurple],
  );
  
  static const overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCC0D47A1),
      Color(0xEE1565C0),
    ],
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFF0A1628),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D1F3C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A2744),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF212121)),
        bodyMedium: TextStyle(color: Color(0xFF212121)),
        bodySmall: TextStyle(color: Color(0xFF757575)),
        titleLarge: TextStyle(color: Color(0xFF212121)),
        titleMedium: TextStyle(color: Color(0xFF212121)),
        titleSmall: TextStyle(color: Color(0xFF757575)),
      ),
    );
  }
}
