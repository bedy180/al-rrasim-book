import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF155B46);
  static const gold = Color(0xFFC5A15A);

  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: brightness,
      primary: brightness == Brightness.dark ? const Color(0xFF77C7A8) : green,
      secondary: gold,
      surface: brightness == Brightness.dark ? const Color(0xFF17221F) : const Color(0xFFF8F7F1),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface.withValues(alpha: .55),
      textTheme: ThemeData(brightness: brightness).textTheme,
      appBarTheme: const AppBarTheme(centerTitle: false, backgroundColor: Colors.transparent),
      cardTheme: CardThemeData(elevation: 0, color: scheme.surfaceContainerHighest.withValues(alpha: .55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
