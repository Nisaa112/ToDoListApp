import 'package:flutter/material.dart';
import '../model/tugas_model.dart';
import '../service/api_service.dart'; // pastikan ada method API-nya
import '../database_helper.dart';     // untuk SQLite

class TugasViewModel extends ChangeNotifier {
  List<TugasModel> _tugasList = [];
  bool _isLoading = false;

  List<TugasModel> get tugasList => _tugasList;
  bool get isLoading => _isLoading;

  Future<void> fetchTugas() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchTugas(); // kamu harus buat ini
      _tugasList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearTugasTable();

      for (var tugas in fromApi) {
        await db.insertTugas(tugas);
        print("✅ Tugas disimpan ke SQLite: ${tugas.title}");
      }
    } catch (e) {
      print('⚠️ Error saat fetch tugas dari API: $e');

      final db = DatabaseHelper.instance;
      _tugasList = await db.getAllTugas();
      print("📦 Mengambil tugas dari SQLite: ${_tugasList.length} item");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTugas(TugasModel tugas) async {
    try {
      final created = await ApiService.createTugas(tugas); // kamu harus buat ini juga

      if (created != null) {
        final db = DatabaseHelper.instance;
        await db.insertTugas(created);
        print("✅ Tugas baru ditambahkan ke SQLite: ${created.title}");

        await fetchTugas();
      }
    } catch (e) {
      print('❌ Error saat tambah tugas: $e');
    }
  }

  Future<void> updateTugas(TugasModel tugas) async {
    try {
      await ApiService.updateTugas(tugas.id!, tugas);
      await fetchTugas();
    } catch (e) {
      print('❌ Error saat update tugas: $e');
    }
  }

  Future<void> deleteTugas(int id) async {
    try {
      await ApiService.deleteTugas(id); // kamu harus buat juga
      await fetchTugas();
    } catch (e) {
      print('❌ Error saat hapus tugas: $e');
    }
  }

  void toggleCheckbox(int index) {
    _tugasList[index].isChecked = !(_tugasList[index].isChecked ?? false);
    notifyListeners();
  }

  void showTugasModal(BuildContext context) {
    bool showSubtask = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 16,
                right: 16,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 📝 TextField tugas utama
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Masukan tugas...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        // 🧩 TextField tugas sampingan (jika aktif)
                        showSubtask
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.radio_button_unchecked, size: 18, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Masukan tugas sampingan...",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),

                        const SizedBox(height: 12),

                        // 🔘 Chips + Icon Send
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: ChoiceChip(
                                      label: Text("Kategori", style: TextStyle(fontSize: 12),),
                                      selected: false,
                                      onSelected: (_) {},
                                    ),
                                  ),
                                  ChoiceChip(
                                    label: Text("Tugas baru"),
                                    selected: showSubtask,
                                    onSelected: (val) {
                                      setState(() {
                                        showSubtask = !showSubtask;
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    label: Text("Kesusahan"),
                                    selected: false,
                                    onSelected: (_) {},
                                  ),
                                  ChoiceChip(
                                    avatar: Icon(Icons.calendar_today, size: 16),
                                    label: Text(""),
                                    selected: false,
                                    onSelected: (_) {},
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: Color(0xFF485F88),
                              onPressed: () {
                                Navigator.pop(context);
                                // Simpan data tugas
                              },
                              child: Icon(Icons.send, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}
