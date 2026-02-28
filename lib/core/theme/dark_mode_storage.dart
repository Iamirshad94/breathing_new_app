import 'package:hive_flutter/hive_flutter.dart';

const String _boxName = 'prefs';
const String _keyDarkMode = 'dark_mode';

/// Saves/loads dark mode in Hive so it survives app restarts.
abstract final class DarkModeStorage {
  static Future<bool> getIsDark() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) await Hive.openBox(_boxName);
      return Hive.box(_boxName).get(_keyDarkMode, defaultValue: false) as bool;
    } catch (_) {
      return false;
    }
  }

  static Future<void> setIsDark(bool value) async {
    try {
      if (!Hive.isBoxOpen(_boxName)) await Hive.openBox(_boxName);
      await Hive.box(_boxName).put(_keyDarkMode, value);
    } catch (_) {
      // Ignore; preference will default to light next launch.
    }
  }
}
