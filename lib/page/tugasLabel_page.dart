import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugasSampingan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

class TugaslabelPage extends StatefulWidget {
  const TugaslabelPage({super.key});

  @override
  State<TugaslabelPage> createState() => _TugaslabelPageState();
}

class _TugaslabelPageState extends State<TugaslabelPage> {
  @override
  Widget build(BuildContext context) {
    final tugasVM = Provider.of<TugasViewModel>(context);
    final tugasSampinganVM = Provider.of<TugasSampinganViewModel>(context);
    final labelVM = Provider.of<LabelViewModel>(context);

    // Ambil labelId dari arguments
    final int labelId = ModalRoute.of(context)!.settings.arguments as int;

    // Filter tugas berdasarkan labelId
    final List<TugasModel> filteredTugas = tugasVM.tugasList
        .where((tugas) => tugas.labelId == labelId)
        .toList();


    // Ambil nama label
    final namaLabel = labelVM.labelList
        .firstWhere((k) => k.id == labelId, orElse: () => labelVM.labelList.first)
        .name;



    return Scaffold(
      backgroundColor: const Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: const Color(0xFF485F88),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          namaLabel ?? "Tugas Label",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        child: filteredTugas.isEmpty
            ? const Center(child: Text("Tidak ada Tugas.", style: TextStyle(color: Colors.blueGrey)))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredTugas.length,
                itemBuilder: (context, index) {
                  final TugasModel tugas = filteredTugas[index];

                  final tanggalFormatted = tugas.date != null
                      ? DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(tugas.date!))
                      : '-';

                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/detailtugas', arguments: tugas.id);
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                      Container(
                                        height: 1,
                                        color: Colors.white60,
                                        margin: const EdgeInsets.only(right: 8),
                                      ),
                                      Text(
                                        '-', // Ganti jika kamu ingin munculkan info tugas sampingan
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    (tugas.isChecked == true)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    tugasVM.toggleCheckbox(index);
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(5, -20),
        child: FloatingActionButton(
          onPressed: () {
            // Arahkan ke halaman tambah tugas kategori, jika ada
          },
          backgroundColor: const Color(0xFF485F88),
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
