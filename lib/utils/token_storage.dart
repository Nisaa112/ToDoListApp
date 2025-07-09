import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<void> saveSerialNumber(String serialNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('serial_number', serialNumber);
  }

  static Future<String?> getSerialNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('serial_number');
  }

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<void> saveTokenType(String tokenType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token_type', tokenType);
  }

  static Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_type');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('serial_number');
    await prefs.remove('user_id');
    await prefs.remove('token_type');
  }
}
