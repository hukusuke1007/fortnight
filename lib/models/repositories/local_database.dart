import 'package:shared_preferences/shared_preferences.dart';

enum LocalDatabaseKey {
  gameClearTime,
  superMode,
}

extension LocalDatabaseKeyExtension on LocalDatabaseKey {
  String get rawValue {
    switch (this) {
      case LocalDatabaseKey.gameClearTime:
        return 'gameClearTime';
      case LocalDatabaseKey.superMode:
        return 'superMode';
    }
    return null;
  }
}

class LocalDatabase {
  LocalDatabase(this._prefs);
  final SharedPreferences _prefs;
  Future<T> load<T>(LocalDatabaseKey key) async {
    if (T.toString() == 'int') {
      return _prefs.getInt(key.rawValue) as T;
    }
    if (T.toString() == 'double') {
      return _prefs.getDouble(key.rawValue) as T;
    }
    if (T.toString() == 'bool') {
      return _prefs.getBool(key.rawValue) as T;
    }
    if (T.toString() == 'String') {
      return _prefs.getString(key.rawValue) as T;
    }
    if (T.toString() == 'List<String>') {
      return _prefs.getStringList(key.rawValue) as T;
    }
    return null;
  }

  Future<bool> save<T>(LocalDatabaseKey key, T value) async {
    if (value is int) {
      return _prefs.setInt(key.rawValue, value);
    }
    if (value is double) {
      return _prefs.setDouble(key.rawValue, value);
    }
    if (value is bool) {
      return _prefs.setBool(key.rawValue, value);
    }
    if (value is String) {
      return _prefs.setString(key.rawValue, value);
    }
    if (value is List<String>) {
      return _prefs.setStringList(key.rawValue, value);
    }
    return false;
  }
}
