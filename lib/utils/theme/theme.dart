import 'package:flutter/material.dart';

ThemeData afyaYanguTheme() {
  return ThemeData(
    // General Colors
    primaryColor: const Color(0xFF2981b3), 
    primaryColorDark: const Color(0xFF073b4c),
    primaryColorLight: const Color(0xff06d6a0), 
    secondaryHeaderColor: const Color(0xffef476f),
    scaffoldBackgroundColor: Colors.white,

    // Typography
 textTheme: const TextTheme(
  displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2981b3)),
  displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2981b3)),
  titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
  bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
  bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
  bodySmall: TextStyle(fontSize: 12, color: Colors.black45),
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2981b3),
      elevation: 2,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2981b3),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF2981b3),
        side: const BorderSide(color: Color(0xFF2981b3), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF2981b3),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF2981b3), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF2981b3), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: const TextStyle(color: Color(0xFF2981b3)),
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: Color(0xFF2981b3),
      size: 24,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF2981b3),
      foregroundColor: Colors.white,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF2981b3),
      unselectedItemColor:  Color(0xFF073b4c),
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      elevation: 5,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: Colors.grey[300],
      thickness: 1,
      space: 1,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(const Color(0xFF2981b3)),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? const Color(0xFF2981b3) :  const Color(0xFF073b4c),
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? const Color(0xFF2981b3) : Colors.grey[400],
      ),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF2981b3),
    ), colorScheme: ColorScheme.fromSwatch(
    ).copyWith(
      secondary: Colors.greenAccent, // Accent color
      surface: Colors.grey[50], // Used for Card and Container backgrounds
      onSurface: Colors.black87, // Text on backgrounds
    ).copyWith(surface: Colors.grey[50]),
  );
}
