import 'package:flutter/material.dart';
import '../helpers/sp_helper.dart';
import '../utils/sp_keys.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _loadSavedTheme();
  }

  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final sp = await SpHelper.getSP();
    await sp.setString(
      keyThemeMode,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  Future<void> toggleTheme() async {
    await setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  Future<void> _loadSavedTheme() async {
    final sp = await SpHelper.getSP();
    final savedMode = sp.getString(keyThemeMode);
    if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }
}
