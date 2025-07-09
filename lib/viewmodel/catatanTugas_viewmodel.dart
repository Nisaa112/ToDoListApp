import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/catatanTugas_model.dart' as catatan;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class CatatanTugasViewModel extends ChangeNotifier {
  List<catatan.Data> _catatanList = [];
  bool _isLoading = false;

  List<catatan.Data> get catatanList => _catatanList;
  bool get isLoading => _isLoading;

  Future<void> fetchCatatanTugas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchCatatanTugas();
      _catatanList = fromApi;

      // Simpan ke SQLite
      final db = DatabaseHelper.instance;
      await db.clearCatatanTugasTable(); // Clear dulu
      for (var catat in fromApi) {
        await db.insertCatatanTugas(catat);
      }
    } catch (e) {
      print("⚠️ Gagal fetch dari API: $e. Ambil dari lokal...");
      _catatanList = await DatabaseHelper.instance.getAllCatatanTugas(); // fallback offline
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> addCatatanTugas(catatan.Data newCatatan) async {
    try {
      final created = await ApiService.createCatatanTugas(newCatatan);
      if (created != null) {
        await DatabaseHelper.instance.insertCatatanTugas(created); // simpan lokal
        _catatanList.add(created);
        notifyListeners();
      }
    } catch (e) {
      print("❌ Error tambah catatan tugas: $e");
    }
  }


  Future<void> updateCatatanTugas(catatan.Data catat, String newNote) async {
    try {
      catat.note = newNote;
      await ApiService.updateCatatanTugas(catat);
      await DatabaseHelper.instance.updateCatatanTugas(catat);
      await fetchCatatanTugas();
    } catch (e) {
      print("❌ Error update catatan tugas: $e");
    }
  }


  Future<void> deleteCatatanTugas(int id) async {
    try {
      await ApiService.deleteCatatanTugas(id);
    } catch (e) {
      print("⚠️ Gagal hapus API: $e, hapus lokal saja...");
    }

    await DatabaseHelper.instance.deleteCatatanTugas(id);
    _catatanList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
