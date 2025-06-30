import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
  final tugasVM = Provider.of<TugasViewModel>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF485F88), size: 30,),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        title: Text("Kalender", style: TextStyle(color: Color(0xFF485F88), fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Color(0xFF485F88),),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focuseDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focuseDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF485F88),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF485F88),
                    width: 2
                  )
                ),
                selectedTextStyle: TextStyle(
                  color: Color(0xFF485F88),
                  fontWeight: FontWeight.bold,
                )
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Color(0xFF485F88),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Color(0xFF485F88)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF485F88),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50)
                  )
                ),
                padding: EdgeInsets.all(16),
                child: tugasVM.tugasList.isEmpty 
                ? Center(child: Text("Tidak ada Tugas."),) 
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tugas",
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tugasVM.tugasList.length,
                        itemBuilder: (context, index) {
                          final tugas = tugasVM.tugasList[index];
                          final String tanggalFormatted = DateFormat('d MMMM yyyy', 'id_ID').format(tugas.tanggal);
                      
                          return Card(
                            color: Color.fromRGBO(238, 241, 248, 1.0),
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
                                    style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
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
                                                color: Color(0xFF485F88),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Container(
                                              height: 1,
                                              width: null, // hanya sepanjang teks
                                              color: Colors.blueGrey,
                                              margin: const EdgeInsets.only(right: 8),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Checkbox icon
                                      IconButton(
                                        icon: Icon(
                                          (tugas.isChecked == true) ? Icons.check_box : Icons.check_box_outline_blank,
                                          color: Color(0xFF485F88),
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
                                    style: const TextStyle(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ) 
              ),
            ),
          )
        ],
      ),
    );
  }
}