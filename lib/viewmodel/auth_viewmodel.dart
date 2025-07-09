import 'package:flutter/material.dart';
import 'package:to_do_list_app/database_helper.dart';
import 'package:to_do_list_app/model/login_response.dart';
import 'package:to_do_list_app/model/user_model.dart' as pengguna;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/service/auth_service.dart';
import 'package:to_do_list_app/utils/token_storage.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String serial, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 🔐 Login dan dapatkan token
      final LoginResponseModel result = await AuthService.login(serial, password);

      await TokenStorage.saveToken(result.token ?? '');
      await TokenStorage.saveSerialNumber(result.serialNumber ?? '');
      await TokenStorage.saveUserId(result.userId ?? 0);
      await TokenStorage.saveTokenType(result.tokenType ?? '');

      // 🧑 Ambil user dari API setelah login
      final pengguna.Data? user = await ApiService.fetchUser();
      if (user != null) {
        await DatabaseHelper.instance.clearUserTable(); // Hapus user sebelumnya
        await DatabaseHelper.instance.insertUser(user);  // Simpan user baru
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearAll();
    notifyListeners();
  }
}
