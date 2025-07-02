import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String selectedKategori = 'Umum'; // Default kategori

  @override
  Widget build(BuildContext context) {
    String tanggalHariIni = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: Color(0xFF485F88),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.check, color: Colors.white, size: 30,),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/pikiran');
            },
          ),
        ),
        title: Text("Catatan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
      body: Stack(
        children: [
          // === Box putih besar, full tinggi ===
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
                    const TextField(
                      decoration: InputDecoration(
                        hintText: "Judul",
                        hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 20),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
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
          ),

          // === Toolbar di atas container putih ===
          Positioned(
            // left: 10,
            right: 24,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12)
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.text_fields, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: Icon(Icons.image, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: Icon(Icons.color_lens, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: Icon(Icons.check_box, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: Icon(Icons.format_list_numbered, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: Icon(Icons.format_list_bulleted, color: Color(0xFF485F88)), onPressed: () {}),
                  IconButton(icon: Icon(Icons.note, color: Color(0xFF485F88)), onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}