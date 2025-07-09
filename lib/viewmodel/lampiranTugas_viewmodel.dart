import 'dart:io';
import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/lampiranTugas_model.dart';
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class LampiranTugasViewModel extends ChangeNotifier {
  List<LampiranTugasModel> _lampiranList = [];
  bool _isLoading = false;

  List<LampiranTugasModel> get lampiranList => _lampiranList;
  bool get isLoading => _isLoading;

  /// Ambil lampiran dari API, lalu sinkron ke SQLite
  /// Jika gagal, ambil dari database lokal
  Future<void> fetchLampiranTugas({int? todoId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ambil dari API
      final fromApi = await ApiService.fetchLampiranTugas();

      // Update list
      _lampiranList = (todoId != null)
          ? fromApi.where((e) => e.todoId == todoId).toList()
          : fromApi;

      // Simpan ke SQLite
      final db = DatabaseHelper.instance;
      await db.clearLampiranTugasTable();
      for (var lampiran in fromApi) {
        await db.insertLampiranTugas(lampiran);
      }
    } catch (e) {
      print("⚠️ Gagal fetch API, fallback SQLite: $e");
      _lampiranList =
          await DatabaseHelper.instance.getAllLampiranTugas(todoId: todoId);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Tambah lampiran dari file dan kirim ke API
  Future<void> addLampiranTugas({
    required int todoId,
    required File file,
  }) async {
    try {
      final lampiran = LampiranTugasModel(
        todoId: todoId,
        file: file.path,
      );

      final created = await ApiService.createLampiranTugas(lampiran);
      if (created != null) {
        await DatabaseHelper.instance.insertLampiranTugas(created);
        await fetchLampiranTugas(todoId: todoId);
      }
    } catch (e) {
      print("❌ Gagal tambah lampiran: $e");
    }
  }

  /// Update metadata lampiran (jika ada)
  Future<void> updateLampiranTugas(LampiranTugasModel lampiran) async {
    try {
      await ApiService.updateLampiranTugas(lampiran);
      await fetchLampiranTugas(todoId: lampiran.todoId);
    } catch (e) {
      print("❌ Gagal update lampiran: $e");
    }
  }

  /// Hapus lampiran dari API dan lokal
  Future<void> deleteLampiranTugas(int id) async {
    try {
      await ApiService.deleteLampiranTugas(id);
    } catch (e) {
      print("⚠️ Gagal hapus API, hapus lokal saja: $e");
    }

    await DatabaseHelper.instance.deleteLampiranTugas(id);
    _lampiranList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
