import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

class KotakPikiranPage extends StatefulWidget {
  const KotakPikiranPage({super.key});

  @override
  State<KotakPikiranPage> createState() => _KotakPikiranPageState();
}

class _KotakPikiranPageState extends State<KotakPikiranPage> {
  @override
  Widget build(BuildContext context) {
    final tugasVM = Provider.of<TugasViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: Color(0xFF485F88),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        title: Text("Kotak Pikiran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white,),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 241, 248, 1.0),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50)
                )
              ),
              padding: EdgeInsets.all(16),
              child: tugasVM.tugasList.isEmpty 
              ? Center(child: Text("Tidak ada Tugas."),) 
              : Column(
                children: [
                  SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tugasVM.tugasList.length,
                      itemBuilder: (context, index) {
                        final tugas = tugasVM.tugasList[index];
                        final String tanggalFormatted = DateFormat('d MMMM yyyy', 'id_ID').format(tugas.tanggal);
                    
                        return Card(
                          color: const Color(0xFF485F88),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tanggal
                                Text(
                                  tanggalFormatted,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                // const SizedBox(height: 8),
                                // Tugas + Icon checkbox
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Nama tugas + Garis
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tugas.nama,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            height: 1,
                                            width: null, // hanya sepanjang teks
                                            color: Colors.white60,
                                            margin: const EdgeInsets.only(right: 8),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ✅ Checkbox icon
                                    IconButton(
                                      icon: Icon(
                                        (tugas.isChecked == true) ? Icons.check_box : Icons.check_box_outline_blank,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        tugasVM.toggleCheckbox(index);
                                      },
                                    )
                                  ],
                                ),
                                // const SizedBox(height: 8),
                                // 🧾 Deskripsi
                                Text(
                                  tugas.deskripsi,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ) 
            ),
          )
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(5, -20), // ⬅️ X: ke kanan, Y: ke atas (minus)
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/catatan');
          },
          backgroundColor: Color(0xFF485F88),
          child: Icon(Icons.add, color: Colors.white),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}