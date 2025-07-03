import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
              prefixIcon: const Icon(Icons.search),
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
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/pengguna');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf2hQMkanNHRB00g7rFrCm4gfpNdLvV2MUPg&s'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text('Annisa Aulia', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('auliaannisa@gmail.com', style: TextStyle(color: Colors.blueGrey)),
                                  ],
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueGrey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
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
              child: tugasVM.tugasList.isEmpty
                  ? const Center(
                      child: Text("Tidak ada tugas.", style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tugasVM.tugasList.length,
                      itemBuilder: (context, index) {
                        final tugas = tugasVM.tugasList[index];
                        final tanggalFormatted = tugas.date != null
                            ? DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.parse(tugas.date!))
                            : '-';

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
                                  Text(tanggalFormatted, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(tugas.title ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                            const SizedBox(height: 2),
                                            Container(height: 1, color: Colors.white60, margin: const EdgeInsets.only(right: 8)),
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
            tugasVM.showTugasModal(context);
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
