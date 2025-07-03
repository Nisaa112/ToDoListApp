import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/page/content/kategori_content.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';

class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final kategoriVM = Provider.of<KategoriViewModel>(context);

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
          "Kategori",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: const KategoriContent(), // tetap
      floatingActionButton: Transform.translate(
        offset: const Offset(5, -20),
        child: FloatingActionButton(
          onPressed: () {
            kategoriVM.showAddKategoriModal(context); // ✅ tanpa endpoint
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
