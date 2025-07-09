import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/model/kategori_model.dart';
import 'package:to_do_list_app/model/label_model.dart';
import 'package:to_do_list_app/model/tugas_sampingan_model.dart';
import '../model/tugas_model.dart';
import '../service/api_service.dart';
import '../database_helper.dart';

class TugasViewModel extends ChangeNotifier {
  final TextEditingController tugasUtamaController = TextEditingController();

  List<TugasModel> _tugasList = [];
  bool _isLoading = false;

  List<TugasModel> get tugasList => _tugasList;
  bool get isLoading => _isLoading;

  List<Data> _tugasSampinganList = [];
  List<Data> get tugasSampinganList => _tugasSampinganList;

  Future<void> fetchTugasSampingan() async {
    try {
      final list = await ApiService.fetchTugasSampingan();
      _tugasSampinganList = list;
      notifyListeners();
    } catch (e) {
      print("Error ambil tugas sampingan: $e");
    }
  }

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

  void toggleCheckbox(int index) async {
    _tugasList[index].isChecked = !(_tugasList[index].isChecked ?? false);

    final tugas = _tugasList[index];
    final db = DatabaseHelper.instance;
    await db.updateTugasChecked(tugas.id!, tugas.isChecked!); // pastikan `id` tidak null

    notifyListeners();
  }

  void toggleCheckboxById(int id) async {
    final index = _tugasList.indexWhere((tugas) => tugas.id == id);
    if (index != -1) {
      final tugas = _tugasList[index];
      tugas.isChecked = !(tugas.isChecked ?? false);

      // 💾 Simpan ke SQLite
      final db = DatabaseHelper.instance;
      await db.updateTugasChecked(id, tugas.isChecked!);

      notifyListeners();
    }
  }


  void selectAll() {
    for (var tugas in _tugasList) {
      tugas.isChecked = true;
    }
    notifyListeners();
  }

  void clearSelection() {
    for (var tugas in _tugasList) {
      tugas.isChecked = false;
    }
    notifyListeners();
  }

  Future<void> deleteSelectedTugas() async {
    final db = DatabaseHelper.instance;
    final selectedTugas = _tugasList.where((t) => t.isChecked == true).toList();

    for (var tugas in selectedTugas) {
      try {
        await ApiService.deleteTugas(tugas.id!); // hapus dari API
        await db.deleteTugas(tugas.id!); // hapus dari SQLite
        print("🗑️ Tugas dengan id ${tugas.id} berhasil dihapus");
      } catch (e) {
        print("❌ Gagal hapus tugas id ${tugas.id}: $e");
      }
    }

    await fetchTugas(); // refresh list
  }

  void sortByDate() {
    _tugasList.sort((a, b) {
      final aDate = DateTime.tryParse(a.date ?? '') ?? DateTime.now();
      final bDate = DateTime.tryParse(b.date ?? '') ?? DateTime.now();
      return aDate.compareTo(bDate);
    });
    notifyListeners();
  }

  void sortByTitle() {
    _tugasList.sort((a, b) {
      final aTitle = a.title ?? '';
      final bTitle = b.title ?? '';
      return aTitle.toLowerCase().compareTo(bTitle.toLowerCase());
    });
    notifyListeners();
  }

  void showTambahTugasDialog(
    BuildContext context, {
    required List<KategoriModel> kategoriList,
    required List<String> difficultyList,
    required List<LabelModel> labelList,
    required Function(TugasModel tugasUtama, List<String> subTasks, DateTime? selectedDueDate, String? repeatType, int? intervalDays, DateTime? endDate) onSubmit,
  }) {
    final titleController = TextEditingController();
    final List<TextEditingController> subtaskControllers = [];
    KategoriModel? selectedKategori;
    String? selectedDifficulty;
    DateTime? selectedDate; // hanya tanggal
    TimeOfDay? selectedTime; // waktu
    String? selectedRepeatType; // seperti: "Setiap Hari", "Setiap Minggu"
    int? selectedIntervalDays; // jika pakai interval
    DateTime? selectedEndDate; // untuk batas akhir pengulangan
    LabelModel? selectedLabel;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> openDeadlineDialog() async {
              DateTime? tempDate = selectedDate ?? DateTime.now();
              TimeOfDay? tempTime = selectedTime ?? TimeOfDay.now();
              String? tempRepeatType = selectedRepeatType;
              int? tempIntervalDays = selectedIntervalDays;
              DateTime? tempEndDate = selectedEndDate;

              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setInnerState) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 📅 Calendar picker
                          CalendarDatePicker(
                            initialDate: tempDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            onDateChanged: (date) => setInnerState(() => tempDate = date),
                          ),
                          const SizedBox(height: 12),
                          // ⏰ Time picker
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: const Text("Waktu"),
                            trailing: Text("${tempTime?.hour.toString().padLeft(2, '0') ?? '00'}:${tempTime?.minute.toString().padLeft(2, '0') ?? '00'}"),
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: tempTime ?? TimeOfDay.now(),
                              );
                              if (picked != null) setInnerState(() => tempTime = picked);
                            },
                          ),
                          // 🔁 Repeat picker
                          ListTile(
                            leading: const Icon(Icons.repeat),
                            title: const Text("Ulangi"),
                            trailing: Text(tempRepeatType ?? "Tidak ada"),
                            onTap: () async {
                              final picked = await showModalBottomSheet<String>(
                                context: context,
                                builder: (_) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(title: const Text("Tidak ada"), onTap: () => Navigator.pop(context, "Tidak ada")),
                                    ListTile(title: const Text("Setiap Hari"), onTap: () => Navigator.pop(context, "daily")),
                                    ListTile(title: const Text("Setiap Minggu"), onTap: () => Navigator.pop(context, "weekly")),
                                    ListTile(title: const Text("Setiap Bulan"), onTap: () => Navigator.pop(context, "monthly")),
                                  ],
                                ),
                              );
                              if (picked != null) setInnerState(() => tempRepeatType = picked == "Tidak ada" ? null : picked);
                            },
                          ),
                          const SizedBox(height: 16),
                          // ✅ Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedDate = tempDate;
                                    selectedTime = tempTime;
                                    selectedRepeatType = tempRepeatType;
                                    selectedIntervalDays = tempRepeatType == "daily"
                                        ? 1
                                        : tempRepeatType == "weekly"
                                            ? 7
                                            : tempRepeatType == "monthly"
                                                ? 30
                                                : null;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Selesai"),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  });
                },
              );
            }

            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                    left: 16,
                    right: 16,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(238, 241, 248, 1.0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 📝 Input tugas utama
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Masukan tugas...",
                              hintStyle: const TextStyle(color: Colors.blueGrey),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          /// 🔘 Chips: kategori, kesusahan, tambah tugas
                          Wrap(
                            spacing: 5,
                            children: [
                              PopupMenuButton<KategoriModel>(
                                onSelected: (kategori) => setState(() => selectedKategori = kategori),
                                itemBuilder: (context) => kategoriList.map((kategori) => PopupMenuItem(
                                  value: kategori,
                                  child: Text(kategori.name ?? "-"),
                                )).toList(),
                                child: Chip(
                                  label: Text(selectedKategori?.name ?? "Kategori", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) => setState(() => selectedDifficulty = value),
                                itemBuilder: (context) => difficultyList.map((d) => PopupMenuItem(
                                  value: d,
                                  child: Text(d),
                                )).toList(),
                                child: Chip(
                                  label: Text(selectedDifficulty ?? "Kesusahan", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              PopupMenuButton<LabelModel>(
                                onSelected: (label) => setState(() => selectedLabel = label),
                                itemBuilder: (context) => labelList.map((label) => PopupMenuItem(
                                  value: label,
                                  child: Text(label.name ?? "-"),
                                )).toList(),
                                child: Chip(
                                  label: Text(selectedLabel?.name ?? "Label", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today, size: 22, color: Colors.blueGrey),
                                onPressed: openDeadlineDialog,
                              ),
                            ],
                          ),
                          /// 🔖 Label + kalender + kirim
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(color: Color(0xFF485F88), shape: BoxShape.circle),
                                child: IconButton(
                                  icon: const Icon(Icons.send, color: Colors.white),
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    final user = await ApiService.fetchUser();

                                    DateTime? dueDate;
                                    if (selectedDate != null && selectedTime != null) {
                                      dueDate = DateTime(
                                        selectedDate!.year,
                                        selectedDate!.month,
                                        selectedDate!.day,
                                        selectedTime!.hour,
                                        selectedTime!.minute,
                                      );
                                    }

                                    final tugasModel = TugasModel(
                                      userId: user?.id,
                                      categoryId: selectedKategori?.id,
                                      title: titleController.text.trim(),
                                      difficult: selectedDifficulty,
                                      dueDate: dueDate?.toIso8601String(),
                                      date: DateTime.now().toIso8601String(),
                                      isChecked: false,
                                      labelId: selectedLabel?.id,
                                    );

                                    final subTasks = subtaskControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();

                                    onSubmit(tugasModel, subTasks, dueDate, selectedRepeatType, selectedIntervalDays, selectedEndDate);
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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