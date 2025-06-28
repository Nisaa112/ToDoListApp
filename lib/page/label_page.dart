import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

class LabelPage extends StatefulWidget {
  const LabelPage({super.key});

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {
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
        title: Text("Pengingat", style: TextStyle(color: Colors.white),),
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
                  topLeft: Radius.circular(50)
                )
              ),
              padding: EdgeInsets.all(16),
              child: tugasVM.tugasList.isEmpty 
              ? Center(child: Text("Tidak ada Tugas."),) 
              : Column(
                children: [
                  SizedBox(height: 16,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tugasVM.tugasList.length,
                      itemBuilder: (context, index) {
                        final tugas = tugasVM.tugasList[index];
                    
                        return Card(
                          
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
    );
  }
}