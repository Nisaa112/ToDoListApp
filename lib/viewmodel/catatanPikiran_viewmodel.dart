import 'package:flutter/material.dart';
import 'package:to_do_list_app/model/catatanPikiran_model.dart';
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/database_helper.dart';

class CatatanPikiranViewModel extends ChangeNotifier {
  List<CatatanPikiranModel> _catatanList = [];
  bool _isLoading = false;

  List<CatatanPikiranModel> get catatanList => _catatanList;
  bool get isLoading => _isLoading;

  Future<void> fetchCatatan() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchCatatanPikiran();
      _catatanList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearCatatanPikiranTable();

      for (var item in fromApi) {
        await db.insertCatatanPikiran(item);
      }
    } catch (e) {
      print("⚠️ Gagal fetch dari API, fallback ke SQLite: $e");
      _catatanList = await DatabaseHelper.instance.getAllCatatanPikiran();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<CatatanPikiranModel?> addCatatan(String judul, String isi, int userId) async {
    final newCatatan = CatatanPikiranModel(judul: judul, isi: isi, userId: userId);

    print("🧠 ViewModel: Menambahkan catatan pikiran:");
    print("- Judul: $judul");
    print("- Isi: $isi");
    print("- UserId: $userId");

    final result = await ApiService.createCatatanPikiran(newCatatan);
    if (result != null) {
      catatanList.add(result);
      notifyListeners();
    }
    return result;
  }

  Future<void> updateCatatan(CatatanPikiranModel catatan, String newJudul, String newIsi) async {
    try {
      catatan.judul = newJudul;
      catatan.isi = newIsi;
      await ApiService.updateCatatanPikiran(catatan);
      await fetchCatatan();
    } catch (e) {
      print("❌ Gagal update catatan: $e");
    }
  }

  Future<void> deleteCatatan(int id) async {
    try {
      await ApiService.deleteCatatanPikiran(id);
    } catch (e) {
      print("⚠️ Gagal hapus API, coba hapus lokal: $e");
    }

    await DatabaseHelper.instance.deleteCatatanPikiran(id);
    _catatanList.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void insertNumberedList(TextEditingController controller) {
    final lines = controller.text.split('\n');
    final formatted = List.generate(lines.length, (i) => "${i + 1}. ${lines[i]}").join('\n');
    controller.text = formatted;
    notifyListeners();
  }

  void insertBulletedList(TextEditingController controller) {
    final lines = controller.text.split('\n');
    final formatted = lines.map((line) => "• $line").join('\n');
    controller.text = formatted;
    notifyListeners();
  }

  }
