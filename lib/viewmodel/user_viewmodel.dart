import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_list_app/model/user_model.dart' as pengguna;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';
import 'package:to_do_list_app/utils/token_storage.dart';

class UserViewModel extends ChangeNotifier {
  pengguna.Data? _user;
  bool _isLoading = false;

  pengguna.Data? get user => _user;
  bool get isLoading => _isLoading;

  set user(pengguna.Data? value) {
    _user = value;
    notifyListeners();
  }

  /// Fetch dari API, fallback ke SQLite jika gagal
  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchUser();
      if (fromApi != null) {
        _user = fromApi;
        await DatabaseHelper.instance.insertUser(_user!);
        print("✅ User disimpan ke SQLite: ${_user!.name}");
      }
    } catch (e) {
      print("⚠️ Gagal ambil user dari API: $e");
      _user = await DatabaseHelper.instance.getUser();
      print("📦 Mengambil user dari SQLite: ${_user?.name ?? 'Tidak ada'}");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUser(pengguna.Data newUser) async {
    try {
      final created = await ApiService.createUser(newUser);
      if (created != null) {
        _user = created;
        await DatabaseHelper.instance.insertUser(_user!);
        print("✅ User dibuat dan disimpan: ${_user!.name}");
        notifyListeners();
      }
    } catch (e) {
      print("❌ Gagal membuat user: $e");
    }
  }

  Future<bool> updateUser(pengguna.Data user) async {
    try {
      await ApiService.updateUser(user);
      await DatabaseHelper.instance.updateUser(user);
      _user = user;
      notifyListeners();
      return true;
    } catch (e) {
      print("❌ Gagal update user: $e");
      return false;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await ApiService.deleteUser(id);
    } catch (e) {
      print("⚠️ Gagal hapus user dari API, hapus dari SQLite: $e");
    }

    await DatabaseHelper.instance.deleteUser(id);
    _user = null;
    notifyListeners();
  }

  Future<void> loadUserFromDb() async {
    _user = await DatabaseHelper.instance.getUser();
    notifyListeners();
  }

  Future<void> uploadPhoto(File imageFile) async {
    final userId = user?.id;
    if (userId == null) throw Exception("User ID null");

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/api/users/$userId/photo'),
    );

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ${await TokenStorage.getToken()}';

    request.files.add(await http.MultipartFile.fromPath('photo_profile', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);

      final updatedUser = pengguna.Data.fromJson(data['data']);
      user = updatedUser;
    } else {
      final errorResponse = await http.Response.fromStream(response);
      throw Exception("Upload gagal: ${errorResponse.body}");
    }
  }

  /// Tambahkan fungsi ini agar bisa reset user (misalnya saat logout)
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
