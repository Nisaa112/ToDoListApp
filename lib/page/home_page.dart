import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
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

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriVM = Provider.of<KategoriViewModel>(context);
    final kategoriList = kategoriVM.kategoriList;
    final tugasVM = Provider.of<TugasViewModel>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
        scrolledUnderElevation: 0, //  matikan bayangan saat scroll
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
                  Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 7),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 20,     // jarak dari sisi kiri
                      endIndent: 20,  // jarak dari sisi kanan
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 265,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7)
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.dashboard_customize, color: Color(0xFF485F88)),
                        title: Text('Semua Kategori', style: TextStyle(fontSize: 15),),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/kategori');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
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
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(Icons.notifications, color: Color(0xFF485F88)),
                            title: Text('Pengingat', style: TextStyle(fontSize: 15)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/pengingat');
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(Icons.favorite, color: Color(0xFF485F88)),
                            title: Text('Favorit', style: TextStyle(fontSize: 15)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/favorit');
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(Icons.archive, color: Color(0xFF485F88)),
                            title: Text('Arsip', style: TextStyle(fontSize: 15)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/arsip');
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(Icons.label, color: Color(0xFF485F88)),
                            title: Text('Label', style: TextStyle(fontSize: 15)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/label');
                            },
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(Icons.bubble_chart, color: Color(0xFF485F88)),
                            title: Text('Kotak Pikiran', style: TextStyle(fontSize: 15)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/pikiran');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Align(
                    child: Container(
                      width: 265,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.settings, color: Color(0xFF485F88)),
                        title: Text('Pengaturan', style: TextStyle(fontSize: 15)),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 38,
              padding: EdgeInsets.only(top: 7),
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
                                color: isSelected ? Color(0xFF485F88) : Color.fromRGBO(157, 172, 205, 1.0),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                kategori.nama,
                                style: TextStyle(
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
                  SizedBox(width: 8,),
                  IconButton(
                    onPressed: () {
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(), // Hapus batasan default
                    icon: Iconify(
                      Mdi.view_grid_outline,
                      size: 25, // Ini penting, ubah sesuai ukuran yang kamu mau
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
            ),


            // list tugas
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                // padding: const EdgeInsets.only(bottom: 100),
                physics: const BouncingScrollPhysics(),
                itemCount: tugasVM.tugasList.length,
                itemBuilder: (context, index) {
                  final tugas = tugasVM.tugasList[index];
                  final tanggalFormatted = DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(tugas.tanggal); // bisa ganti dengan tugas.tanggal jika ada

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/detailtugas');
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  );
                },
              ),
            )
          ],
        ),
      ),
      // FAB
      // extendBody: true, // biar FAB 'masuk' ke BottomAppBar
      floatingActionButton: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromRGBO(238, 241, 248, 1.0),
            width: 5,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xFF485F88),
          elevation: 4, // tambahkan jika ingin efek bayangan
          child: Icon(Icons.add, color: Colors.white),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(238, 241, 248, 1.0),
              width: 5
            )
          )
        ),
        child: SizedBox(
          height: 60,
          child: BottomAppBar(
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
}
