import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/model/login_response.dart';

class AuthService {
  static const String baseUrl = 'https://cockatoo-electric-unduly.ngrok-free.app/api/login';

  static Future<LoginResponseModel> login(String serial, String password) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Accept': 'application/json'},
      body: {
        'serial_number': serial,
        'password': password,
      },
    );

    print("🔐 Login response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return LoginResponseModel.fromJson(json);
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }
}
