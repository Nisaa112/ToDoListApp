import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodel/kategori_viewmodel.dart';
import '../viewmodel/tugas_viewmodel.dart';
import '../model/tugas_model.dart';
import '../widgets/custom_bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final TextEditingController _searchController = TextEditingController();
  int? _selectedKategoriId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final kategoriVM = Provider.of<KategoriViewModel>(context, listen: false);
    if (_selectedKategoriId == null && kategoriVM.kategoriList.isNotEmpty) {
      _selectedKategoriId = kategoriVM.kategoriList.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriVM = Provider.of<KategoriViewModel>(context);
    final tugasVM = Provider.of<TugasViewModel>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF485F88), size: 30,),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            controller: _searchController, // Gunakan controller
            decoration: InputDecoration(
              hintText: 'Cari...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear(); // kosongkan isi
                        });
                      },
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFF485F88), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Color(0xFF485F88), width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {}); // supaya suffixIcon muncul/hilang saat diketik
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Color(0xFF485F88)),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // 🔼 Bagian profil dan list tile lainnya
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/pengguna');
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf2hQMkanNHRB00g7rFrCm4gfpNdLvV2MUPg&s'),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Annisa Aulia', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('auliaannisa@gmail.com', style: TextStyle(color: Colors.blueGrey)),
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueGrey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,     // jarak dari sisi kiri
                    endIndent: 20,  // jarak dari sisi kanan
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.dashboard_customize, color: Color(0xFF485F88)),
                    title: Text('Semua Kategori'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/kategori');
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.notifications, color: Color(0xFF485F88)),
                    title: Text('Pengingat'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/pengingat');
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.favorite, color: Color(0xFF485F88)),
                    title: Text('Favorit'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/favorit');
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.archive, color: Color(0xFF485F88)),
                    title: Text('Arsip'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/arsip');
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.label, color: Color(0xFF485F88)),
                    title: Text('Label'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/label');
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.bubble_chart, color: Color(0xFF485F88)),
                    title: Text('Kotak Pikiran'),
                    onTap: () {},
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.settings, color: Color(0xFF485F88)),
                    title: Text('Pengaturan'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/pengaturan');
                    },
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,     // jarak dari sisi kiri
              endIndent: 20,  // jarak dari sisi kanan
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 30),
              leading: Icon(Icons.logout, color: Color(0xFF485F88)),
              title: Text('Keluar', style: TextStyle(color: Color(0xFF485F88))),
              onTap: () {
                // Log out logic di sini
                Navigator.pop(context);
                // misalnya redirect ke halaman login
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            SizedBox(height: 20), // biar ga mentok ke bawah banget
          ],
        ),
      ),

      // kategori
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: kategoriVM.kategoriList.length,
                itemBuilder: (context, index) {
                  final kategori = kategoriVM.kategoriList[index];
                  final isSelected = kategori.id == _selectedKategoriId;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedKategoriId = kategori.id;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF485F88) : Color(0xFF98A8C7),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          kategori.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // list tugas
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                
                itemCount: tugasVM.tugasList.length,
                itemBuilder: (context, index) {
                  final tugas = tugasVM.tugasList[index];
                  print(tugas.isChecked.runtimeType); // untuk pastikan nilainya bool
                  final tanggalFormatted = DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(tugas.tanggal); // bisa ganti dengan tugas.tanggal jika ada

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
            )


          ],
        ),
      ),
      // FAB
      extendBody: true, // biar FAB 'masuk' ke BottomAppBar
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF485F88),
        child: Icon(Icons.add, color: Colors.white),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(), // bentuk cekungan
        notchMargin: 8, // jarak antara FAB dan AppBar
        color: Color(0xFF485F88),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.card_giftcard, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

    );
  }
}
