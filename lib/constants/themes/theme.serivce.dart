import 'package:app_stories/app/app_sp.dart';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeService() {
    _loadThemeFromPreferences();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _saveThemeToPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    _isDarkMode = AppSP.get('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemeToPreferences() async {
    await AppSP.set('isDarkMode', _isDarkMode);
  }
}
