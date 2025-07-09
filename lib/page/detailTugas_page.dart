import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/label_model.dart';
import 'package:to_do_list_app/model/lampiranTugas_model.dart' as lampiranModel;
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/model/tugas_sampingan_model.dart' as sampingan;
import 'package:to_do_list_app/model/ulangiTugas_model.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/lampiranTugas_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugasSampingan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/kategori_user_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/catatanTugas_viewmodel.dart';
import 'package:to_do_list_app/model/catatanTugas_model.dart' as catatanModel;


class DetailTugasPage extends StatefulWidget {
  const DetailTugasPage({super.key});

  @override
  State<DetailTugasPage> createState() => _DetailTugasPageState();
}


class _DetailTugasPageState extends State<DetailTugasPage> {
  List<sampingan.Data> tugasSampinganList = [];
  TextEditingController _controllerTugas = TextEditingController();
  TugasModel? tugas; 
  UlangiTugasModel? ulangiTugas; 
  List<LabelModel> labelList = []; // untuk modal label
  bool _showFormTugasSampingan = false;
  TextEditingController _subtaskController = TextEditingController();
  List<lampiranModel.LampiranTugasModel> _lampiranList = [];

  Future<void> simpanCatatanTugas(String isiCatatan) async {
    if (tugas == null || tugas!.id == null) {
      print("🚫 Tugas belum tersedia. Tidak bisa simpan catatan.");
      return;
    }

    final newCatatan = catatanModel.Data(
      todoId: tugas!.id,
      note: isiCatatan,
      createdAt: DateTime.now().toIso8601String(),
    );

    print("📝 Catatan dikirim: ${newCatatan.toJson()}"); // pastikan kamu punya toJson()

    try {
      final vm = Provider.of<CatatanTugasViewModel>(context, listen: false);
      await vm.addCatatanTugas(newCatatan);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Catatan tugas berhasil disimpan")),
      );
    } catch (e) {
      print("❌ Error tambah catatan tugas: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan catatan: $e")),
      );
    }
  }


  Future<void> _simpanSemua() async {
    if (tugas == null || tugas!.id == null) return;

    final tugasVM = Provider.of<TugasViewModel>(context, listen: false);

    // Update judul tugas (kalau ada perubahan)
    tugas!.title = _controllerTugas.text.trim();
    await tugasVM.updateTugas(tugas!);

    // Simpan catatan kalau ada isinya
    final isiCatatan = ""; // Ganti dengan controller kalau kamu pakai
    if (isiCatatan.isNotEmpty) {
      await simpanCatatanTugas(isiCatatan);
    }

    // TODO: simpan tugas sampingan, ulangi tugas, dll kalau perlu

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perubahan disimpan")),
    );
  }



  @override
  void initState() {
    super.initState();
    print("🔄 Init DetailTugasPage");
    Future.microtask(() {
      print("🔍 Memeriksa arguments...");
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null) {
        print("❌ ERROR: Arguments null");
        return;
      }
      
      final mapArgs = args as Map;
      print("📦 Arguments content: $mapArgs");
      
      tugas = mapArgs['tugas'] as TugasModel?;
      if (tugas == null) {
        print("⚠️ Objek tugas null");
        return;
      }

      print("✅ Judul tugas diterima: ${tugas!.title}"); // Debug log
      _controllerTugas.text = tugas!.title ?? ''; // Pastikan null check
      tugasSampinganList = mapArgs['subtasks'] ?? [];

      // Ambil label dari VM
      final labelVM = Provider.of<LabelViewModel>(context, listen: false);
      labelVM.fetchLabel().then((_) {
        setState(() {
          labelList = labelVM.labelList;
        });
      });

      // Ambil kategori pengguna dari VM
      final kategoriUserVM = Provider.of<KategoriUserViewModel>(context, listen: false);
      kategoriUserVM.fetchKategoriUser (); // Ambil kategori pengguna
    });
  }

  void _updateSubtaskStatus(int index, bool? value) async {
    setState(() {
      tugasSampinganList[index].isDone = value ?? false; // Jika value null, set ke false
    });

    // Update status di database lokal
    final tugasSampinganVM = Provider.of<TugasSampinganViewModel>(context, listen: false);
    
    // Memperbarui tugas sampingan dengan judul dan status baru
    await tugasSampinganVM.updateTugasSampingan(
      tugasSampinganList[index], // Objek Data
      tugasSampinganList[index].title ?? '', // Judul yang ada
      tugasSampinganList[index].isDone ?? false // Status baru, gunakan false jika null
    );

    // Update status di API
    try {
      await TugasViewModel().updateTugas(tugas!); // Hanya satu argumen yang diperlukan
    } catch (e) {
      print("❌ Gagal mengupdate tugas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: Color(0xFF485F88),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.check, color: Color.fromRGBO(238, 241, 248, 1.0), size: 30),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        title: Text(
          "Detail Tugas",
          style: TextStyle(
            color: Color.fromRGBO(238, 241, 248, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true, // klik luar untuk tutup
                builder: (BuildContext context) {
                  return Center(
                    child: Container(
                      width: 280,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.favorite_border),
                              title: const Text('Tambahkan Favorit'),
                              onTap: () async {
                                setState(() {
                                  tugas?.isFavorite = true;
                                  print("⭐ Ditandai sebagai favorit: ${tugas?.title} (ID: ${tugas?.id})");
                                });

                                if (tugas != null) {
                                  final tugasVM = Provider.of<TugasViewModel>(context, listen: false);
                                  await tugasVM.updateTugas(tugas!);
                                }

                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.archive_outlined),
                              title: const Text('Tambahkan Arsip'),
                              onTap: () async {
                                setState(() {
                                  tugas?.isArchived = true;
                                  print("📦 Ditandai sebagai arsip: ${tugas?.title} (ID: ${tugas?.id})");
                                });

                                if (tugas != null) {
                                  final tugasVM = Provider.of<TugasViewModel>(context, listen: false);
                                  await tugasVM.updateTugas(tugas!);
                                }

                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.label),
                              title: const Text('Tambahkan Label'),
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Pilih Label'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: labelList.map((label) {
                                        return ListTile(
                                          title: Text(label.name ?? '-'),
                                          onTap: () {
                                            setState(() {
                                              tugas?.labelId = label.id;
                                              print("🏷️ Label dipilih: ${label.name} (ID: ${label.id}) untuk tugas '${tugas?.title}'");
                                            });
                                            Navigator.pop(ctx);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.delete, color: Colors.red),
                              title: const Text('Hapus Tugas', style: TextStyle(color: Colors.red)),
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Hapus Tugas?'),
                                    content: const Text('Yakin ingin menghapus tugas ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // TODO: hapus dari ViewModel/API
                                          Navigator.pop(ctx);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 241, 248, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 120), // extra padding bawah biar ga ketutup toolbar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Tanggal dan kategori ===
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now()),
                          style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            // Tampilkan modal kategori pengguna
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const Text('Pilih Kategori'),
                                  content: Consumer<KategoriUserViewModel>(
                                    builder: (context, kategoriUserVM, child) {
                                      return kategoriUserVM.isLoading
                                          ? Center(child: CircularProgressIndicator())
                                          : ListView.builder(
                                              itemCount: kategoriUserVM.kategoriList.length,
                                              itemBuilder: (context, index) {
                                                final kategori = kategoriUserVM.kategoriList[index];
                                                return ListTile(
                                                  title: Text(kategori.name ?? '-'),
                                                  onTap: () {
                                                    setState(() {
                                                      tugas?.labelId = kategori.id; // Set labelId tugas
                                                    });
                                                    Navigator.pop(ctx); // Tutup modal
                                                  },
                                                );
                                              },
                                            );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            children: const [
                              Text("Kategori", style: TextStyle(color: Colors.blueGrey)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controllerTugas,
                      decoration: const InputDecoration(
                        hintText: "Judul",
                        hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 20),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (value) {
                        setState(() {
                          tugas?.title = value;
                        });
                      },
                    ),
                    const SizedBox(height: 1),
                    ListView.builder(
                      itemCount: tugasSampinganList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final tugasSampingan = tugasSampinganList[index];
                        final data = tugasSampingan;

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Checkbox(
                            value: data?.isDone ?? false,
                            onChanged: (val) {
                              _updateSubtaskStatus(index, val); // Update status saat checkbox diubah
                            },
                          ),
                          title: Text(
                            data?.title ?? '(Tidak ada judul)',
                            style: TextStyle(
                              decoration: (data?.isDone ?? false)
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            (data?.createdAt != null)
                                ? DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.parse(data!.createdAt!))
                                : 'Tanpa tanggal',
                            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Color(0xFF485F88)),
                            onPressed: () {
                              setState(() {
                                tugasSampinganList.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 10,),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                    SizedBox(height: 20,),
                    // BATAS WAKTU
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            tugas?.dueDate = selectedDate.toIso8601String();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xFF485F88)),
                          SizedBox(width: 15),
                          Text("Batas Waktu", style: TextStyle(fontSize: 14, color: Color(0xFF485F88))),
                          Spacer(),
                          Text(
                            tugas?.dueDate != null
                                ? DateFormat('dd/MM/yyyy').format(DateTime.parse(tugas!.dueDate!))
                                : "Belum diatur",
                            style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),


                    // CATATAN
                    InkWell(
                      onTap: () {
                        if (tugas?.id != null) {
                          Navigator.pushNamed(context, '/catatantugas', arguments: tugas);
                          } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Tugas belum tersedia.")),
                          );
                          }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.note_add, color: Color(0xFF485F88)),
                          SizedBox(width: 15),
                          Text("Catatan", style: TextStyle(fontSize: 14, color: Color(0xFF485F88))),
                          Spacer(),
                          Text("Tambah", style: TextStyle(color: Colors.blueGrey, fontSize: 10)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // LAMPIRAN
                    InkWell(
                      onTap: () async {
                        final picked = await FilePicker.platform.pickFiles();

                        if (picked != null && picked.files.single.path != null) {
                          final filePath = picked.files.single.path!;
                          final fileName = picked.files.single.name;
                          final fileExtension = fileName.split('.').last;

                          if (tugas?.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Tugas belum tersedia")),
                            );
                            return;
                          }

                          final newLampiran = lampiranModel.LampiranTugasModel(
                            todoId: tugas!.id,
                            file: filePath,
                          );

                          final vm = Provider.of<LampiranTugasViewModel>(context, listen: false);
                          await vm.addLampiranTugas(
                            todoId: tugas!.id!,
                            file: File(filePath),
                          );


                          _lampiranList.add(newLampiran);
                          setState(() {});

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Lampiran berhasil ditambahkan")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Tidak ada file yang dipilih")),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.link, color: Color(0xFF485F88)),
                          SizedBox(width: 15),
                          Text("Lampiran", style: TextStyle(fontSize: 14, color: Color(0xFF485F88))),
                          Spacer(),
                          Text("Tambah", style: TextStyle(color: Colors.blueGrey, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}