import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  @override
  Widget build(BuildContext context) {
    final labelVM = Provider.of<LabelViewmodel>(context);

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
        title: Text("Kategori", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 241, 248, 1.0),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Card(
                        color: Color(0xFF485F88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Column(
                            children: List.generate(labelVM.labelList.length, (index) {
                              final label = labelVM.labelList[index];
                      
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.tag, color: Colors.white),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          label.nama,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.more_vert, color: Colors.white),
                                        onPressed: () {
                                          
                                        },
                                      ),
                                    ],
                                  ),
                                  if (index != labelVM.labelList.length - 1)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.white30,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(5, -20), // ⬅️ X: ke kanan, Y: ke atas (minus)
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xFF485F88),
          child: Icon(Icons.add, color: Colors.white),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}