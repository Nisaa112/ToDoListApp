// import 'package:flutter/material.dart';
// import 'package:to_do_list_app/model/tugas_sampingan_model.dart';
// import 'package:to_do_list_app/service/api_service.dart';
// import 'package:to_do_list_app/database_helper.dart';

// class TugasSampinganViewModel extends ChangeNotifier {
//   List<Data> _tugasSampinganList = [];
//   bool _isLoading = false;

//   List<Data> get tugasSampinganList => _tugasSampinganList;
//   bool get isLoading => _isLoading;

//   Future<void> fetchTugasSampingan() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final fromApi = await ApiService.fetchTugasSampingan();
//       _tugasSampinganList = fromApi;

//       final db = DatabaseHelper.instance;
//       await db.clearTugasSampinganTable();
//       for (var item in fromApi) {
//         await db.insertTugasSampingan(item);
//       }
//     } catch (e) {
//       print("⚠️ Gagal fetch dari API: $e. Ambil dari lokal...");
//       _tugasSampinganList = await DatabaseHelper.instance.getAllTugasSampingan();
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> addTugasSampingan(Data newData) async {
//     try {
//       final created = await ApiService.createTugasSampingan(newData);
//       if (created != null) {
//         await DatabaseHelper.instance.insertTugasSampingan(created);
//         await fetchTugasSampingan();
//       }
//     } catch (e) {
//       print("❌ Error tambah tugas sampingan: $e");
//     }
//   }

//   Future<void> updateTugasSampingan(Data tugas, String newTitle, bool newIsDone) async {
//     try {
//       tugas.title = newTitle;
//       tugas.isDone = newIsDone;
//       await ApiService.updateTugasSampingan(tugas);
//       await fetchTugasSampingan();
//     } catch (e) {
//       print("❌ Error update tugas sampingan: $e");
//     }
//   }

//   Future<void> deleteTugasSampingan(int id) async {
//     try {
//       await ApiService.deleteTugasSampingan(id);
//     } catch (e) {
//       print("⚠️ Gagal hapus dari API, lanjut hapus lokal: $e");
//     }

//     await DatabaseHelper.instance.deleteTugasSampingan(id);
//     _tugasSampinganList.removeWhere((item) => item.id == id);
//     notifyListeners();
//   }
  
//   Future<List<Data>> fetchTugasSampinganByTodoId(int todoId) async {
//     try {
//       final db = DatabaseHelper.instance;
//       final result = await db.getTugasSampinganByTodoId(todoId);
//       return result;
//     } catch (e) {
//       print("❌ Error ambil tugas sampingan untuk todoId $todoId: $e");
//       return [];
//     }
//   }

//   /// Versi yang hanya ambil satu (untuk tampilan Home)
//   Future<Data?> getSingleTugasSampinganByTodoId(int todoId) async {
//     final list = await fetchTugasSampinganByTodoId(todoId);
//     return list.isNotEmpty ? list.first : null;
//   }

// }
