import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/viewmodel/tugasSampingan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TugasViewModel>(context, listen: false).fetchTugas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tugasVM = Provider.of<TugasViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: const Color(0xFF485F88),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/home');
          },
        ),
        title: const Text(
          "Favorit",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(238, 241, 248, 1.0),
          borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
        ),
        padding: const EdgeInsets.all(16),
        child: tugasVM.tugasList.isEmpty
            ? const Center(
                child: Text(
                  "Tidak ada Tugas.",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: tugasVM.tugasList.length,
                itemBuilder: (context, index) {
                  final TugasModel tugas = tugasVM.tugasList[index];

                  // Tampilkan hanya tugas yang difavoritkan
                  if (tugas.isFavorite == true) {
                    final tanggalFormatted = tugas.date != null
                        ? DateFormat('d MMMM yyyy', 'id_ID')
                            .format(DateTime.parse(tugas.date!))
                        : '-';

                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          '/detailtugas',
                          arguments: {'tugas': tugas},
                        );
                      },
                      child: Card(
                        color: const Color(0xFF485F88),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tanggalFormatted,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                tugas.title ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                height: 1,
                                color: Colors.white60,
                                margin: const EdgeInsets.only(right: 8),
                              ),
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
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(); // Jangan tampilkan tugas yang tidak difavoritkan
                  }
                },
              ),
      ),
    );
  }
}
