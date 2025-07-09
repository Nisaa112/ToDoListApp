import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/catatanTugas_model.dart' as model;
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/viewmodel/catatanTugas_viewmodel.dart';

class NotestugasPage extends StatefulWidget {
  const NotestugasPage({super.key});

  @override
  State<NotestugasPage> createState() => _NotestugasPageState();
}

class _NotestugasPageState extends State<NotestugasPage> {
  TugasModel? tugas;
  final TextEditingController _isiController = TextEditingController();
  int? _catatanTugasId;
  int? tugasId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      tugasId = args['tugasId'];
      print("📌 tugasId diterima: $tugasId");

      // Lalu kamu bisa fetch catatan sesuai tugasId ini, misal:
      if (tugasId != null) {
        final vm = Provider.of<CatatanTugasViewModel>(context, listen: false);
        vm.fetchCatatanTugas();
      }
    } else {
      print("⚠️ Argument tidak valid: $args");
    }
  }


  @override
  void dispose() {
    _isiController.dispose();
    super.dispose();
  }

  void _showConfirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              _isiController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Catatan dihapus")),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _simpanCatatan() async {
    final isi = _isiController.text.trim();

    if (tugas == null || tugas!.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tugas belum tersedia")),
      );
      return;
    }

    final newCatatan = model.Data(
      todoId: tugas!.id, // ✅ INI YANG WAJIB
      note: isi,
      createdAt: DateTime.now().toIso8601String(),
    );

    final viewModel = Provider.of<CatatanTugasViewModel>(context, listen: false);
    await viewModel.addCatatanTugas(newCatatan);

    final latest = viewModel.catatanList.lastOrNull;
    if (latest != null && latest.id != null) {
      setState(() {
        _catatanTugasId = latest.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Catatan berhasil disimpan")),
      );

      // ⬅️ Tambahkan ini untuk kembali ke halaman sebelumnya
      Navigator.pop(context, latest); 
    }
  }

  @override
  Widget build(BuildContext context) {
    tugas ??= ModalRoute.of(context)?.settings.arguments as TugasModel?;
    String tanggalHariIni =
        DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: const Color(0xFF485F88),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.check, color: Colors.white, size: 30),
          onPressed: _simpanCatatan,
        ),
        title: const Text(
          "Catatan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _showConfirmDelete, 
          ),
        ],
      ),
      body: Container(
        height: double.infinity, 
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFEEF1F8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tanggalHariIni,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _isiController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "Catatan...",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
