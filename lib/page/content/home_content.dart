import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/kategori_model.dart';
import 'package:to_do_list_app/model/tugas_sampingan_model.dart' as sampingan;
import 'package:to_do_list_app/model/ulangiTugas_model.dart' as ulangi;
import 'package:to_do_list_app/model/user_model.dart' as pengguna;
import 'package:to_do_list_app/service/api_service.dart';
import 'package:to_do_list_app/viewmodel/auth_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugasSampingan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/user_viewmodel.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedKategoriId;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final kategoriVM = Provider.of<KategoriViewModel>(context, listen: false);
      final tugasVM = Provider.of<TugasViewModel>(context, listen: false);
      final tugasSampinganVM = Provider.of<TugasSampinganViewModel>(context, listen: false);
      final labelVM = Provider.of<LabelViewModel>(context, listen: false);
      final userVM = Provider.of<UserViewModel>(context, listen: false);

      await kategoriVM.fetchKategori();
      await labelVM.fetchLabel();

      // ✅ Pastikan _selectedKategoriId ter-set lebih dulu
      if (mounted && _selectedKategoriId == null && kategoriVM.kategoriList.isNotEmpty) {
        setState(() {
          _selectedKategoriId = kategoriVM.kategoriList.first.id;
        });
      }

      // Baru fetch tugas dan lainnya setelah kategoriId sudah ada
      await tugasVM.fetchTugas();
      await tugasSampinganVM.fetchTugasSampingan();
      await userVM.fetchUser ();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kategoriVM = Provider.of<KategoriViewModel>(context);
    final kategoriList = [
      // Ini kategori khusus "Semua"
      KategoriModel(id: 0, name: 'Semua'),
      ...kategoriVM.kategoriList,
    ];

    final labelVM = Provider.of<LabelViewModel>(context, listen: false);
    final labelList = labelVM.labelList;
    final tugasVM = Provider.of<TugasViewModel>(context);
    final tugasList = tugasVM.tugasList;
    final difficultyList = ['Mudah', 'Sedang', 'Sulit'];

    if (_selectedKategoriId == null && kategoriList.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedKategoriId = kategoriList.first.id;
        });
      });
    }

    // Filter tugas untuk hanya menampilkan yang tidak diarsipkan
    final filteredTugas = tugasList.where((tugas) {
      final cocokKategori = (_selectedKategoriId == 0 || tugas.categoryId == _selectedKategoriId);
      final tidakDiarsip = !(tugas.isArchived ?? false);
      return cocokKategori && tidakDiarsip;
    }).toList();


    return Scaffold(
      backgroundColor: const Color.fromRGBO(238, 241, 248, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(238, 241, 248, 1.0),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF485F88), size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari...',
              hintStyle: TextStyle(color: Colors.blueGrey),
              prefixIcon: const Icon(Icons.search, color: Colors.blueGrey,),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFF485F88), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color(0xFF485F88), width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF485F88)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  final tugasVM = Provider.of<TugasViewModel>(context, listen: false);

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.select_all, color: Color(0xFF485F88)),
                          title: const Text('Pilih Semua'),
                          onTap: () {
                            tugasVM.selectAll();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.redAccent),
                          title: const Text('Hapus Semua yang Dipilih'),
                          onTap: () async {
                            await tugasVM.deleteSelectedTugas();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("🗑️ Tugas terpilih berhasil dihapus")),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.cancel, color: Colors.grey),
                          title: const Text('Batal Pilih Semua'),
                          onTap: () {
                            tugasVM.clearSelection();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.sort, color: Color(0xFF485F88)),
                          title: const Text('Urutkan berdasarkan Tanggal'),
                          onTap: () {
                            final tugasVM = Provider.of<TugasViewModel>(context, listen: false);
                            tugasVM.sortByDate();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.sort_by_alpha, color: Color(0xFF485F88)),
                          title: const Text('Urutkan berdasarkan Judul'),
                          onTap: () {
                            final tugasVM = Provider.of<TugasViewModel>(context, listen: false);
                            tugasVM.sortByTitle();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 20),
                children: [
                  FutureBuilder<pengguna.Data?>(
                    future: ApiService.fetchUser (),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: LinearProgressIndicator(),
                        );
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Gagal memuat user'),
                        );
                      }

                      final user = snapshot.data!;
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/pengguna');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: const NetworkImage('https://i.pinimg.com/474x/d7/95/c3/d795c373a0539e64c7ee69bb0af3c5c3.jpg') as ImageProvider,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(user.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        Text(user.email ?? '-', style: const TextStyle(color: Colors.blueGrey)),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueGrey),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 7),
                    child: Divider(color: Colors.grey, thickness: 1, indent: 20, endIndent: 20),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 265,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        leading: const Icon(Icons.dashboard_customize, color: Color(0xFF485F88)),
                        title: const Text('Semua Kategori', style: TextStyle(fontSize: 15)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/kategori');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 265,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          buildDrawerTile(context, Icons.notifications, 'Pengingat', '/pengingat'),
                          buildDrawerTile(context, Icons.favorite, 'Favorit', '/favorit'),
                          buildDrawerTile(context, Icons.archive, 'Arsip', '/arsip'),
                          buildDrawerTile(context, Icons.label, 'Label', '/label'),
                          buildDrawerTile(context, Icons.bubble_chart, 'Kotak Pikiran', '/pikiran'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    child: Container(
                      width: 265,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        leading: const Icon(Icons.settings, color: Color(0xFF485F88)),
                        title: const Text('Pengaturan', style: TextStyle(fontSize: 15)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/pengaturan');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey, thickness: 1, indent: 20, endIndent: 20),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 30),
              leading: const Icon(Icons.logout, color: Color(0xFF485F88)),
              title: const Text('Keluar', style: TextStyle(color: Color(0xFF485F88))),
              onTap: () async {
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                await authViewModel.logout(); // Hapus token

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kategoriListView(kategoriList), 
            const SizedBox(height: 16),
            Expanded(
              child: filteredTugas.isEmpty
                ? const Center(
                    child: Text("Tidak ada tugas.", style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredTugas.length,
                    itemBuilder: (context, index) {
                      final tugas = filteredTugas[index];
                      // ⏩ Dapatkan VM dan subTasks dalam urutan yang benar
                      final tugasSampinganVM = Provider.of<TugasSampinganViewModel>(context, listen: false);
                      final subTasks = tugasSampinganVM.tugasSampinganList
                          .where((s) => s.todoId == tugas.id)
                          .toList();

                      final tanggalFormatted = tugas.date != null
                          ? DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(tugas.date!))
                          : '-';

                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/detailTugas', arguments: {
                            'tugas': tugas, // Kirim objek tugas ke halaman detail
                          });
                        },
                        child: Card(
                          color: const Color(0xFF485F88),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tanggalFormatted,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                Row(
                                  children: [
                                    // Checkbox untuk select tugas
                                    Checkbox(
                                      value: tugas.isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          tugas.isSelected = value ?? false;
                                        });
                                      },
                                      checkColor: Color(0xFF485F88),
                                      activeColor: Colors.white,
                                      side: BorderSide(color: Colors.white),
                                    ),

                                    // Expanded untuk teks dan subtask
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tugas.title ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          if (subTasks.isNotEmpty)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: subTasks.map((sub) => Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Text(
                                                  '- ${sub.title}',
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              )).toList(),
                                            ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 1,
                                            color: Colors.white60,
                                            margin: const EdgeInsets.only(right: 8),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        // ✅ Checkbox status "selesai"
                                        IconButton(
                                          icon: Icon(
                                            (tugas.isChecked == true)
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            print('✅ Checkbox ditekan untuk tugas dengan ID: ${tugas.id}');
                                            print('Sebelum: ${tugas.isChecked}');

                                            tugasVM.toggleCheckbox(index);

                                            print('Sesudah: ${tugasVM.tugasList[index].isChecked}');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromRGBO(238, 241, 248, 1.0), width: 5),
        ),
        child: FloatingActionButton(
          onPressed: () {
            final kategoriVM = Provider.of<KategoriViewModel>(context, listen: false);
            final tugasVM = Provider.of<TugasViewModel>(context, listen: false);

            tugasVM.showTambahTugasDialog(
              context,
              kategoriList: kategoriList,
              difficultyList: difficultyList,
              labelList: labelList,
              onSubmit: (tugasUtama, subTasks, selectedDeadline, repeatType, intervalDays, repeatEndDate) async {
                // 💾 Simpan tugas utama ke backend
                final tugasVM = Provider.of<TugasViewModel>(context, listen: false);
                await tugasVM.addTugas(tugasUtama);

                // 🧩 Tambahkan subtask jika ada
                for (var sub in subTasks) {
                  final subtask = sampingan.Data(
                    todoId: tugasUtama.id,
                    title: sub,
                    isDone: false,
                    createdAt: DateTime.now().toIso8601String(),
                  );
                  await ApiService.createTugasSampingan(subtask);
                }

                // 🔁 Tambahkan ulangi tugas jika diatur
                if (repeatType != null && selectedDeadline != null) {
                  final ulangiData = ulangi.Data(
                    todoId: tugasUtama.id,
                    repeatType: repeatType,
                    intervalDays: intervalDays,
                    startDate: selectedDeadline.toIso8601String(),
                    endDate: repeatEndDate?.toIso8601String(),
                  );
                  await ApiService.createUlangiTugas(ulangiData); // ✅ Kirim hanya `Data`, bukan `UlangiTugasModel`
                }
              }
            );
          },

          backgroundColor: const Color(0xFF485F88),
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromRGBO(238, 241, 248, 1.0), width: 7)),
        ),
        child: SizedBox(
          height: 60,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 2,
            color: Color(0xFF485F88),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/home");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.card_giftcard, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/kalender");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerTile(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 20),
      leading: Icon(icon, color: const Color(0xFF485F88)),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget kategoriListView(List kategoriList) {
    return Container(
      height: 38,
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        children: [
          
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: kategoriList.length,
              itemBuilder: (context, index) {
                final kategori = kategoriList[index];
                final isSelected = kategori.id == _selectedKategoriId;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedKategoriId = kategori.id;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                       
                        color: isSelected ? const Color(0xFF485F88) : const Color.fromRGBO(157, 172, 205, 1.0),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        kategori.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/kategori");
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Iconify(
              Mdi.view_grid_outline,
              size: 25,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
