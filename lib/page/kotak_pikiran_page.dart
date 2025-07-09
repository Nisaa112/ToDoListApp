import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/model/catatanPikiran_model.dart';
import 'package:to_do_list_app/viewmodel/catatanPikiran_viewmodel.dart';

class KotakPikiranPage extends StatefulWidget {
  const KotakPikiranPage({super.key});

  @override
  State<KotakPikiranPage> createState() => _KotakPikiranPageState();
}

class _KotakPikiranPageState extends State<KotakPikiranPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CatatanPikiranViewModel>(context, listen: false).fetchCatatan();
  }

  @override
  Widget build(BuildContext context) {
    final catatanVM = Provider.of<CatatanPikiranViewModel>(context);

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
          "Kotak Pikiran",
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
        child: catatanVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : catatanVM.catatanList.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada Catatan Pikiran.",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: catatanVM.catatanList.length,
                    itemBuilder: (context, index) {
                      final CatatanPikiranModel catatan = catatanVM.catatanList[index];

                      final tanggalFormatted = catatan.createdAt != null
                          ? DateFormat('d MMMM yyyy', 'id_ID')
                              .format(DateTime.parse(catatan.createdAt!))
                          : '-';

                      return Card(
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
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                catatan.judul ?? '(Tanpa Judul)',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                catatan.isi ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
            Navigator.pop(context);
            Navigator.pushNamed(context, '/catatanPikiran'); // Menuju halaman tambah catatan
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
