import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/ulangiTugas_model.dart' as ulangi;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class UlangiTugasViewModel extends ChangeNotifier {
  List<ulangi.Data> _ulangiList = [];
  bool _isLoading = false;

  List<ulangi.Data> get ulangiList => _ulangiList;
  bool get isLoading => _isLoading;

  Future<void> fetchUlangiTugas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchUlangiTugas();
      _ulangiList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearUlangiTugasTable();

      for (var item in fromApi) {
        await db.insertUlangiTugas(item);
      }
    } catch (e) {
      print("⚠️ Gagal fetch API, fallback ke SQLite: $e");
      _ulangiList = await DatabaseHelper.instance.getAllUlangiTugas();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUlangiTugas(ulangi.Data data) async {
    try {
      final created = await ApiService.createUlangiTugas(data);
      if (created != null) {
        await DatabaseHelper.instance.insertUlangiTugas(created);
        await fetchUlangiTugas();
      }
    } catch (e) {
      print("❌ Gagal tambah ulangi tugas: $e");
    }
  }

  Future<void> updateUlangiTugas(ulangi.Data data) async {
    try {
      await ApiService.updateUlangiTugas(data);
      await fetchUlangiTugas();
    } catch (e) {
      print("❌ Gagal update ulangi tugas: $e");
    }
  }

  Future<void> deleteUlangiTugas(int id) async {
    try {
      await ApiService.deleteUlangiTugas(id);
    } catch (e) {
      print("⚠️ Gagal hapus dari API, coba hapus lokal: $e");
    }

    await DatabaseHelper.instance.deleteUlangiTugas(id);
    _ulangiList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
