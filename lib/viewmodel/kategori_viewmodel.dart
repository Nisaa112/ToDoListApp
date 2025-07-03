import 'package:flutter/material.dart';
import 'package:to_do_list_app/service/api_service.dart';
import '../model/kategori_model.dart';
import 'package:to_do_list_app/database_helper.dart';

class KategoriViewModel extends ChangeNotifier {
  List<KategoriModel> _kategoriList = [];
  bool _isLoading = false;

  List<KategoriModel> get kategoriList => _kategoriList;
  bool get isLoading => _isLoading;

  Future<void> fetchKategori() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fromApi = await ApiService.fetchKategori();
      _kategoriList = fromApi;

      final db = DatabaseHelper.instance;
      await db.clearKategoriTable();

      for (var kategori in fromApi) {
        await db.insertKategori(kategori);
        print("✅ Kategori disimpan ke SQLite: ${kategori.name}");
      }
    } catch (e) {
      print('⚠️ Error saat fetch kategori dari API: $e');

      final db = DatabaseHelper.instance;
      _kategoriList = await db.getAllKategori();
      print("📦 Mengambil kategori dari SQLite: ${_kategoriList.length} item");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addKategori(String name) async {
    try {
      final newKategori = KategoriModel(name: name);
      final created = await ApiService.createKategori(newKategori);

      if (created != null) {
        final db = DatabaseHelper.instance;
        await db.insertKategori(created);
        print("✅ Kategori baru ditambahkan ke SQLite: ${created.name}");

        await fetchKategori(); // Refresh UI
      }
    } catch (e, stacktrace) {
      print('❌ Error saat tambah kategori: $e');
      print('📛 Stacktrace: $stacktrace');
    }
  }

  Future<void> updateKategori(KategoriModel kategori, String newName) async {
    try {
      kategori.name = newName;
      await ApiService.updateKategori(kategori);
      await fetchKategori();
    } catch (e) {
      print('❌ Error saat update kategori: $e');
    }
  }

  Future<void> deleteKategori(int id) async {
    try {
      await ApiService.deleteKategori(id);
    } catch (e) {
      if (e.toString().contains("404") || e.toString().contains("Kategori tidak ditemukan")) {
        print("⚠️ Data tidak ditemukan di API. Hapus dari SQLite saja.");
      } else {
        print("❌ Gagal menghapus dari API: $e");
        rethrow;
      }
    }

    print("🧹 Menghapus dari SQLite...");
    await DatabaseHelper.instance.deleteKategori(id);

    _kategoriList.removeWhere((item) => item.id == id);
    notifyListeners();

    final sisa = await DatabaseHelper.instance.getAllKategori();
    print("📦 Sisa kategori di SQLite: ${sisa.map((e) => e.name).toList()}");
  }

  void showAddKategoriModal(BuildContext context) {
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
                          hintText: "Masukan Kategori...",
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
                          await addKategori(name);
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

  void showDeleteKategoriModal(BuildContext context, int kategoriId, String kategoriName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Apakah kamu yakin ingin menghapus kategori '$kategoriName'?",
                textAlign: TextAlign.center, // teks di tengah
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center, // tombol di tengah
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.close, size: 18, color: Colors.white),
              label: const Text("Batal", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF485F88),
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
                Navigator.of(ctx).pop(); // Tutup modal dulu
                await deleteKategori(kategoriId);
              },
            ),
          ],
        );
      },
    );
  }
}
