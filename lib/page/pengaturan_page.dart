import 'package:flutter/material.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool kunciTugas = true;
  bool notifikasi= false;
  bool refleksi= true;

  @override
  Widget build(BuildContext context) {
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
        title: Text("Pengaturan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    // BOX 1 - Pengaturan Pengguna\
                    InkWell(
                      onTap: () {
                        // Aksi ketika diklik
                        Navigator.pushNamed(context, '/pengguna'); 
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                        width: 330,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.black),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Pengaturan Pengguna",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),

                    // BOX GABUNGAN - Semua Switch Pengaturan
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(16),
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Kunci Tugas
                          Row(
                            children: [
                              Icon(Icons.key, color: Colors.black),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kunci Tugas",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Tugas akan terkunci selama tugas sebelumnya belum selesai.",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Switch(
                                value: kunciTugas,
                                activeColor: Color(0xFF485F88),
                                onChanged: (bool value) {
                                  setState(() {
                                    kunciTugas = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          Divider(thickness: 1, color: Colors.grey[300]),

                          // Notifikasi
                          Row(
                            children: [
                              Icon(Icons.notifications, color: Colors.black),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Notifikasi",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Notifikasi pengingat tugas.",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Switch(
                                value: notifikasi,
                                activeColor: Color(0xFF485F88),
                                onChanged: (bool value) {
                                  setState(() {
                                    notifikasi = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          Divider(thickness: 1, color: Colors.grey[300]),

                          // Refleksi
                          Row(
                            children: [
                              Icon(Icons.self_improvement, color: Colors.black),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Refleksi",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "Setiap tugas selesai, akan muncul refleksi saat menyelesaikan tugas",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Switch(
                                value: refleksi,
                                activeColor: Color(0xFF485F88),
                                onChanged: (bool value) {
                                  setState(() {
                                    refleksi = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // BOX 5
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                      width: 330,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.brightness_6, color: Colors.black),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Tema Aplikasi",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text("Gelap", style: TextStyle(color: Colors.blueGrey),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}