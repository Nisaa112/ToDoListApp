import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list_app/model/tugas_sampingan_model.dart';

class DetailTugasPage extends StatefulWidget {
  const DetailTugasPage({super.key});

  @override
  State<DetailTugasPage> createState() => _DetailTugasPageState();
}

class _DetailTugasPageState extends State<DetailTugasPage> {
  List<TugasSampinganModel> tugasSampinganList = TugasSampinganModel.getTugasSampinganList();
  TextEditingController _controllerTugas = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: Color(0xFF485F88),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.check, color: Color.fromRGBO(238, 241, 248, 1.0), size: 30),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        title: Text(
          "Detail Tugas",
          style: TextStyle(
            color: Color.fromRGBO(238, 241, 248, 1.0),
            fontWeight: FontWeight.bold,
          ),
        ),
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
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 1),
                    ListView.builder(
                      itemCount: tugasSampinganList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final tugas = tugasSampinganList[index];
                        final tanggalFormatted = DateFormat('dd MMM yyyy', 'id_ID').format(tugas.tanggal);

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          leading: Checkbox(
                            value: tugas.isDone ?? false,
                            onChanged: (val) {
                              setState(() {
                                tugas.isDone = val!;
                              });
                            },
                          ),
                          title: Text(
                            tugas.nama,
                            style: TextStyle(
                              decoration: (tugas.isDone ?? false) ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text(tanggalFormatted, style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Color(0xFF485F88)),
                            onPressed: () {
                              setState(() {
                                tugasSampinganList.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Icon(Icons.add, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Tambahkan tugas sampingan",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF485F88),),
                        SizedBox(width: 15,),
                        Text(
                          "Batas Waktu",
                          style: TextStyle(
                            fontSize: 14, 
                            color: Color(0xFF485F88)
                          ),
                        ),
                        Spacer(),
                        Text(
                          "25/6/2025",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Icon(Icons.alarm, color: Color(0xFF485F88),),
                        SizedBox(width: 15,),
                        Text(
                          "Pengingat",
                          style: TextStyle(
                            fontSize: 14, 
                            color: Color(0xFF485F88)
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Tidak ada",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Icon(Icons.repeat, color: Color(0xFF485F88),),
                        SizedBox(width: 15,),
                        Text(
                          "Ulangi Tugas",
                          style: TextStyle(
                            fontSize: 14, 
                            color: Color(0xFF485F88)
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Tidak ada",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Icon(Icons.note_add, color: Color(0xFF485F88),),
                        SizedBox(width: 15,),
                        Text(
                          "Catatan",
                          style: TextStyle(
                            fontSize: 14, 
                            color: Color(0xFF485F88)
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Tambah",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Icon(Icons.link, color: Color(0xFF485F88),),
                        SizedBox(width: 15,),
                        Text(
                          "lampiran",
                          style: TextStyle(
                            fontSize: 14, 
                            color: Color(0xFF485F88)
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Tambah",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}