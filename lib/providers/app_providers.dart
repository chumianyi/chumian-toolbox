import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  static const String _key = 'theme_mode';

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

class FavoritesProvider extends ChangeNotifier {
  Set<String> _favorites = {};
  List<String> _recent = [];
  static const String _favKey = 'favorites';
  static const String _recentKey = 'recent';

  Set<String> get favorites => _favorites;
  List<String> get recent => _recent;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(_favKey)?.toSet() ?? {};
    _recent = prefs.getStringList(_recentKey) ?? [];
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _favorites.toList());
  }

  Future<void> addRecent(String id) async {
    _recent.remove(id);
    _recent.insert(0, id);
    if (_recent.length > 20) _recent = _recent.sublist(0, 20);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, _recent);
  }

  Future<void> clearRecent() async {
    _recent.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, []);
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, []);
  }
}
