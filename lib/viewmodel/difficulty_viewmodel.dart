import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/difficulty_model.dart';
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class DifficultyViewModel extends ChangeNotifier {
  List<DifficultyModel> _difficultyList = [];
  bool _isLoading = false;

  List<DifficultyModel> get difficultyList => _difficultyList;
  bool get isLoading => _isLoading;

  Future<void> fetchDifficulty() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchDifficulty();
      _difficultyList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearDifficultyTable();

      for (var item in fromApi) {
        await db.insertDifficulty(item);
      }
    } catch (e) {
      print('⚠️ Gagal fetch difficulty dari API: $e');
      _difficultyList = await DatabaseHelper.instance.getAllDifficulty();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDifficulty(String name) async {
    try {
      final newItem = DifficultyModel(name: name);
      final created = await ApiService.createDifficulty(newItem);
      if (created != null) {
        await DatabaseHelper.instance.insertDifficulty(created);
        await fetchDifficulty(); // refresh UI
      }
    } catch (e) {
      print('❌ Gagal tambah difficulty: $e');
    }
  }

  Future<void> updateDifficulty(DifficultyModel item, String newName) async {
    try {
      item.name = newName;
      await ApiService.updateDifficulty(item);
      await fetchDifficulty();
    } catch (e) {
      print('❌ Error update difficulty: $e');
    }
  }

  Future<void> deleteDifficulty(int id) async {
    try {
      await ApiService.deleteDifficulty(id);
    } catch (e) {
      print('⚠️ Error API saat hapus difficulty: $e');
    }

    await DatabaseHelper.instance.deleteDifficulty(id);
    _difficultyList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
