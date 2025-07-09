import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/lampiranPikiran_model.dart' as model;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/utils/file_export.dart';
import 'package:to_do_list_app/viewmodel/catatanPikiran_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/lampiranPikiran_viewmodel.dart' as lampiranp;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  String selectedKategori = 'Umum';
  int? _catatanPikiranId;
  List<model.Data> _lampiranList = [];

  @override
  void dispose() {
    _judulController.dispose();
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
              _judulController.clear();
              _isiController.clear();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Catatan dihapus")));
            },
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('Arsipkan'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Catatan diarsipkan")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Tambahkan Tag'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur tag belum tersedia")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Tambahkan ke Favorit'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ditambahkan ke favorit")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                _showConfirmDelete();
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Ekspor TXT'),
              onTap: () async {
                Navigator.pop(context);
                await exportTxt(_judulController.text, _isiController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Catatan berhasil diekspor ke TXT")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _simpanCatatan() async {
    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();

    final user = await ApiService.fetchUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil data pengguna")),
      );
      return;
    }

    final viewModel = Provider.of<CatatanPikiranViewModel>(context, listen: false);
    final result = await viewModel.addCatatan(judul, isi, user.id!);

    if (result != null && result.id != null) {
      setState(() {
        _catatanPikiranId = result.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Catatan berhasil disimpan")),
      );

      // ⬅️ Tambahkan ini untuk kembali ke halaman sebelumnya
      Navigator.pop(context, result); // bisa kirim result juga jika ingin refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    String tanggalHariIni = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: const Color(0xFF485F88),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.check, color: Colors.white, size: 30),
          onPressed: _simpanCatatan,
        ),
        title: const Text("Catatan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEEF1F8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tanggalHariIni,
                          style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: const [
                              Text("Pribadi", style: TextStyle(color: Colors.blueGrey)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _judulController,
                      decoration: const InputDecoration(
                        hintText: "Judul",
                        hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 20),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 24),
                    Text("Lampiran:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    const SizedBox(height: 8),
                    _lampiranList.isEmpty
                      ? const Text("Belum ada lampiran", style: TextStyle(color: Colors.grey))
                      : Wrap(
                          spacing: 10, 
                          runSpacing: 10,
                          children: _lampiranList.map((lampiran) {
                            final isImage = ['jpg', 'jpeg', 'png', 'gif']
                                .contains(lampiran.fileType?.toLowerCase() ?? '');

                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final result = await OpenFile.open(lampiran.filePath!);
                                  if (result.type != ResultType.done) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Gagal membuka file")),
                                    );
                                  }
                                },
                                child: isImage
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(lampiran.filePath!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.insert_drive_file, color: Colors.blueGrey, size: 40),
                                          SizedBox(height: 4),
                                          Text("File", style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                              ),
                            );
                          }).toList(),
                        ),

                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // right: 50,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.color_lens, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.check_box, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(
                    icon: const Icon(Icons.format_list_numbered, color: Color(0xFF485F88)),
                    onPressed: () {
                      final vm = Provider.of<CatatanPikiranViewModel>(context, listen: false);
                      vm.insertNumberedList(_isiController);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted, color: Color(0xFF485F88)),
                    onPressed: () {
                      final vm = Provider.of<CatatanPikiranViewModel>(context, listen: false);
                      vm.insertBulletedList(_isiController);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.note, color: Color(0xFF485F88)),
                    onPressed: () async {
                      final picked = await FilePicker.platform.pickFiles();

                      if (picked != null && picked.files.single.path != null) {
                        final filePath = picked.files.single.path!;
                        final fileName = picked.files.single.name;
                        final fileExtension = fileName.split('.').last;

                        final user = await ApiService.fetchUser();
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Gagal mendapatkan data pengguna")),
                          );
                          return;
                        }

                        // 🔁 Simpan catatan dulu jika belum ada ID
                        if (_catatanPikiranId == null) {
                          final judul = _judulController.text.trim();
                          final isi = _isiController.text.trim();

                          final viewModel = Provider.of<CatatanPikiranViewModel>(context, listen: false);
                          final result = await viewModel.addCatatan(judul, isi, user.id!);

                          if (result != null && result.id != null) {
                            _catatanPikiranId = result.id;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Catatan otomatis disimpan sebelum menambahkan lampiran")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Gagal menyimpan catatan untuk lampiran")),
                            );
                            return;
                          }
                        }

                        final newLampiran = model.Data(
                          userId: user.id,
                          catatanPikiranId: _catatanPikiranId.toString(),
                          filePath: filePath,
                          fileType: fileExtension,
                        );

                        final lampiranVM = Provider.of<lampiranp.LampiranPikiranViewModel>(context, listen: false);
                        await lampiranVM.addLampiranPikiran(newLampiran);
                        _lampiranList.add(newLampiran);
                        setState(() {}); // agar UI update

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Lampiran berhasil ditambahkan")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Tidak ada file yang dipilih")),
                        );
                      }
                    }

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
