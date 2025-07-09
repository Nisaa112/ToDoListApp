  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:to_do_list_app/service/auth_service.dart';
  import '../model/login_response.dart';
  import '../model/user_model.dart';

  class AuthViewModel extends ChangeNotifier {
    bool _isLoading = true;
    bool get isLoading => _isLoading;

    bool _isInitialized = false;
    bool get isInitialized => _isInitialized;

    bool _isLoggedIn = false;
    bool get isLoggedIn => _isLoggedIn;

    String? _name;
    String? _serialNumber;
    String? _photoProfile; // ✅ konsisten
    String? _token;

    String? get name => _name;
    String? get serialNumber => _serialNumber;
    String? get photoProfile => _photoProfile;
    String? get token => _token;

    String? errorMessage;

    Future<void> login(String serialNumber, String password) async {
      try {
        final loginData = await AuthService.login(serialNumber, password);
        final userModel = await AuthService.getUserById(loginData.userId!);
        final user = userModel.data!.first;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginData.token ?? '');
        await prefs.setString('serial_number', loginData.serialNumber ?? '');
        await prefs.setInt('user_id', loginData.userId!);
        await prefs.setString('name', user.name ?? '');
        await prefs.setString('photo_profile', user.photoProfile ?? '');

        _token = loginData.token;
        _serialNumber = loginData.serialNumber;
        _name = user.name;
        _photoProfile = user.photoProfile;
        _isLoggedIn = true;

        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }

    Future<void> logout() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        try {
          await AuthService.logout(token);
        } catch (e) {
          // abaikan error
        }
      }

      await prefs.clear();

      _isLoggedIn = false;
      _token = null;
      _name = null;
      _serialNumber = null;
      _photoProfile = null;

      notifyListeners();
    }

    Future<void> loadUserFromPrefs() async {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      _name = prefs.getString('name');
      _serialNumber = prefs.getString('serial_number');

      final localPhoto = prefs.getString('profile_image_path');
      _photoProfile = localPhoto ?? prefs.getString('photo_profile');

      _isLoggedIn = _token != null;
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }

    void updateName(String newName) async {
      _name = newName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', newName);
      notifyListeners();
    }
  }
