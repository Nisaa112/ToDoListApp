import 'package:flutter/material.dart';
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
      final result = await AuthService.login(serial, password);
      await TokenStorage.saveToken(result.token);
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
}
