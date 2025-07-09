import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/kategori_user_mode.dart';
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class KategoriUserViewModel extends ChangeNotifier {
  List<KategoriUserModel> _kategoriList = [];
  bool _isLoading = false;

  List<KategoriUserModel> get kategoriList => _kategoriList;
  bool get isLoading => _isLoading;

  Future<void> fetchKategoriUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchKategoriUser();
      _kategoriList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearKategoriUserTable();

      for (var item in fromApi) {
        await db.insertKategoriUser(item);
      }
    } catch (e) {
      print("⚠️ Gagal fetch kategori user dari API: $e");
      _kategoriList = await DatabaseHelper.instance.getAllKategoriUser();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addKategoriUser(String name, int userId) async {
    try {
      final newItem = KategoriUserModel(name: name, userId: userId);
      final created = await ApiService.createKategoriUser(newItem);

      if (created != null) {
        await DatabaseHelper.instance.insertKategoriUser(created);
        await fetchKategoriUser();
      }
    } catch (e) {
      print("❌ Gagal tambah kategori user: $e");
    }
  }

  Future<void> updateKategoriUser(KategoriUserModel kategori, String newName) async {
    try {
      kategori.name = newName;
      await ApiService.updateKategoriUser(kategori);
      await fetchKategoriUser();
    } catch (e) {
      print("❌ Gagal update kategori user: $e");
    }
  }

  Future<void> deleteKategoriUser(int id) async {
    try {
      await ApiService.deleteKategoriUser(id);
    } catch (e) {
      print("⚠️ Gagal hapus dari API, coba hapus lokal: $e");
    }

    await DatabaseHelper.instance.deleteKategoriUser(id);
    _kategoriList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
