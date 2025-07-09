import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/lampiranPikiran_model.dart' as lampiranp;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class LampiranPikiranViewModel extends ChangeNotifier {
  List<lampiranp.Data> _lampiranList = [];
  bool _isLoading = false;

  List<lampiranp.Data> get lampiranList => _lampiranList;
  bool get isLoading => _isLoading;

  Future<void> fetchLampiranPikiran() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchLampiranPikiran();
      _lampiranList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearLampiranPikiranTable();

      for (var item in fromApi) {
        await db.insertLampiranPikiran(item);
      }
    } catch (e) {
      print("⚠️ Gagal fetch API, fallback SQLite: $e");
      _lampiranList = await DatabaseHelper.instance.getAllLampiranPikiran();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLampiranPikiran(lampiranp.Data lampiran) async {
    try {
      final created = await ApiService.createLampiranPikiran(lampiran);
      if (created != null) {
        await DatabaseHelper.instance.insertLampiranPikiran(created);
        await fetchLampiranPikiran();
      }
    } catch (e) {
      print("❌ Gagal tambah lampiran pikiran: $e");
    }
  }

  Future<void> updateLampiranPikiran(lampiranp.Data lampiran) async {
    try {
      await ApiService.updateLampiranPikiran(lampiran);
      await fetchLampiranPikiran();
    } catch (e) {
      print("❌ Gagal update lampiran pikiran: $e");
    }
  }

  Future<void> deleteLampiranPikiran(int id) async {
    try {
      await ApiService.deleteLampiranPikiran(id);
    } catch (e) {
      print("⚠️ Gagal hapus API, hapus lokal saja: $e");
    }

    await DatabaseHelper.instance.deleteLampiranPikiran(id);
    _lampiranList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
