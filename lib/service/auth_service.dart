import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/model/login_response.dart';
import 'package:to_do_list_app/model/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://cockatoo-electric-unduly.ngrok-free.app/api';

  // LOGIN
  static Future<LoginResponseModel> login(String serial, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json'},
        body: {
          'serial_number': serial,
          'password': password,
        },
      ).timeout(const Duration(seconds: 30));

      print("🔐 Login response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // Langsung parsing dari json, karena tidak ada 'status'
        return LoginResponseModel.fromJson(json);
      } else {
        throw Exception('Login gagal: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Login melebihi batas waktu, coba lagi.');
    }
  }


  // LOGOUT
  static Future<void> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      print("🚪 Logout response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] != true) {
          throw Exception(json['message'] ?? 'Logout gagal di server');
        }
      } else {
        throw Exception('Logout gagal: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Logout melebihi batas waktu, coba lagi.');
    }
  }

  // GET USER BY ID
  static Future<UserModel> getUserById(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ambil token dari storage

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan ini
      },
    );

    if (!response.headers['content-type']!.contains('application/json')) {
      throw Exception('⚠️ Response bukan JSON:\n${response.body}');
    }

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil data user: ${response.statusCode}');
    }
  }

} 
