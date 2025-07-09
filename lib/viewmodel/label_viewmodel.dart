import 'package:flutter/material.dart';
import 'package:to_do_list_app/database_helper.dart';
import 'package:to_do_list_app/utils/token_storage.dart';
import '../model/label_model.dart';
import '../service/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LabelViewModel extends ChangeNotifier {
  List<LabelModel> _labelList = [];
  bool _isLoading = false;

  List<LabelModel> get labelList => _labelList;
  bool get isLoading => _isLoading;

  Future<void> fetchLabel() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchLabel();
      _labelList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearLabelTable();

      for (var label in fromApi) {
        await db.insertLabel(label); // ✅ ini harus insertLabel, bukan insertKategori
        print("✅ Label disimpan ke SQLite: ${label.name}");
      }
    } catch (e) {
      print('⚠️ Error saat fetch label dari API: $e');

      final db = DatabaseHelper.instance;
      _labelList = await db.getAllLabel();
      print("📦 Mengambil label dari SQLite: ${_labelList.length} item");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLabel(LabelModel label) async {
    try {
      final userId = await TokenStorage.getUserId(); // ✅ ambil user_id
      if (userId == null || userId == 0) {
        print('❌ User ID tidak ditemukan saat tambah label');
        return;
      }

      label.userId = userId; // ✅ tetapkan user_id ke label

      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        await DatabaseHelper.instance.insertLabel(label);
      } else {
        final newLabel = await ApiService.createLabel(label);
        if (newLabel != null) {
          await DatabaseHelper.instance.insertLabel(newLabel);
          _labelList.add(newLabel);
        }
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error tambah label: $e');
    }
  }

  Future<void> updateLabel(LabelModel label) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      await DatabaseHelper.instance.updateLabel(label); // update lokal tetap dilakukan

      if (connectivity != ConnectivityResult.none) {
        await ApiService.updateLabel(label); // sync ke API jika online
      }

      final index = _labelList.indexWhere((e) => e.id == label.id);
      if (index != -1) {
        _labelList[index] = label;
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error update label: $e');
    }
  }

  Future<void> deleteLabel(int id) async {
    try {
      await DatabaseHelper.instance.deleteLabel(id);

      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity != ConnectivityResult.none) {
        await ApiService.deleteLabel(id);
      }

      _labelList.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print('❌ Error hapus label: $e');
    }
  }

  /// Modal Tambah Label
  void showAddLabelModal(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(238, 241, 248, 1.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Masukan Label...",
                          hintStyle: const TextStyle(color: Colors.blueGrey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF485F88),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Color(0xFFEEF1F8)),
                        onPressed: () async {
                          final name = controller.text.trim();
                          if (name.isEmpty) return;

                          Navigator.of(context).pop();
                          final userId = await TokenStorage.getUserId();
                          await addLabel(LabelModel(name: name, userId: userId));

                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteLabelModal(BuildContext context, int labelId, String labelName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(238, 241, 248, 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Apakah kamu yakin ingin menghapus label '$labelName'?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.close, size: 18, color: Colors.white),
              label: const Text("Batal", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF485F88),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete, color: Colors.white, size: 18),
              label: const Text("Hapus", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await deleteLabel(labelId);
              },
            ),
          ],
        );
      },
    );
  }
}
