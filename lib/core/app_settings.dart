import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool darkMode = false;
  double fontScale = 1;
  Set<int> bookmarks = {};
  static const _darkKey = 'dark_mode';
  static const _fontKey = 'font_scale';
  static const _marksKey = 'bookmarks';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool(_darkKey) ?? false;
    fontScale = prefs.getDouble(_fontKey) ?? 1;
    bookmarks = (prefs.getStringList(_marksKey) ?? []).map(int.parse).toSet();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }

  Future<void> setFontScale(double value) async {
    fontScale = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontKey, value);
  }

  Future<void> toggleBookmark(int verse) async {
    bookmarks.contains(verse) ? bookmarks.remove(verse) : bookmarks.add(verse);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_marksKey, bookmarks.map((e) => e.toString()).toList());
  }
}
