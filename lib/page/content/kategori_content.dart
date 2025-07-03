import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';

class KategoriContent extends StatefulWidget {
  const KategoriContent({super.key});

  @override
  State<KategoriContent> createState() => _KategoriContentState();
}

class _KategoriContentState extends State<KategoriContent> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() {
        Provider.of<KategoriViewModel>(context, listen: false).fetchKategori();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriVM = Provider.of<KategoriViewModel>(context);

    return SizedBox.expand(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(238, 241, 248, 1.0),
          borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
        ),
        child: kategoriVM.kategoriList.isEmpty
            ? const Center(
                child: Text(
                  "Tidak ada kategori",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : SingleChildScrollView(
                // physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                          color: const Color(0xFF485F88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Column(
                              children: List.generate(kategoriVM.kategoriList.length, (index) {
                                final kategori = kategoriVM.kategoriList[index];
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.tag, color: Colors.white, size: 20),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              kategori.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.white),
                                            onPressed: () {
                                              final kategori = kategoriVM.kategoriList[index];
                                              kategoriVM.showDeleteKategoriModal(
                                                context,
                                                kategori.id!,
                                                kategori.name ?? '',
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index != kategoriVM.kategoriList.length - 1)
                                      const Divider(thickness: 1, color: Colors.white30),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
