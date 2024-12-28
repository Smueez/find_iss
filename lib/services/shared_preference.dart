import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static SharedPreferences? _preferences;

  // Initialize the SharedPreferences instance once
  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // Write methods
  static Future<void> writeString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static Future<void> writeInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  static Future<void> writeBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Read methods
  static String readString(String key, {String defaultValue = ""}) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  static int? readInt(String key, {int defaultValue = 0}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  static bool? readBool(String key, {bool defaultValue = false}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  // Remove specific key
  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all keys
  static Future<void> clearAll() async {
    await _preferences?.clear();
  }

  // Write Map (for auth_user or any object)
  static Future<void> writeMap(String key, Map<String, dynamic> value) async {
    String jsonString = jsonEncode(value); // Convert map to JSON string
    await _preferences?.setString(key, jsonString);
  }
}
