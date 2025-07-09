import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromRGBO(238, 241, 248, 1.0),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF485F88),                      // Warna utama
      onPrimary: Colors.white,                         // Warna teks di atas primary
      secondary: Color.fromRGBO(157, 172, 205, 1.0),    // Aksen lembut
      onSecondary: Colors.blueGrey,                    // Teks abu
      error: Colors.grey,                              // Untuk line
      onError: Colors.white,                           // Teks putih
      background: Color.fromRGBO(238, 241, 248, 1.0),   // Warna latar
      onBackground: Colors.black,                      // Teks hitam
      surface: Colors.white,                           // Sekunder lagi
      onSurface: Colors.blueAccent                     // Link
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.blueGrey),
      bodySmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Color(0xFF485F88), fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF485F88)), // default icon
  );

  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromRGBO(8, 10, 17, 1.0),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF485F88),                        // Warna utama
      onPrimary: Colors.white,                           // Warna teks di atas primary
      secondary: Color.fromRGBO(157, 172, 205, 1.0),      // Aksen lembut
      onSecondary: Colors.blueGrey,                      // Teks abu
      error: Colors.grey,                                // Line
      onError: Colors.white,                             // Teks putih
      background: Color.fromRGBO(8, 10, 17, 1.0),         // Background
      onBackground: Colors.white,                        // Teks default
      surface: Color.fromRGBO(18, 21, 36, 1.0),           // Secondary lagi
      onSurface: Colors.blueAccent                       // Link
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.blueGrey),
      bodySmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Color(0xFF485F88), fontWeight: FontWeight.bold),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF485F88)), // default icon
  );
}
