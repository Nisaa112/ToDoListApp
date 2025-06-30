import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/page/arsip_page.dart';
import 'package:to_do_list_app/page/favorit_page.dart';
import 'package:to_do_list_app/page/home_page.dart';
import 'package:to_do_list_app/page/kalender_page.dart';
import 'package:to_do_list_app/page/kategori_page.dart';
import 'package:to_do_list_app/page/kotak_pikiran_page.dart';
import 'package:to_do_list_app/page/label_page.dart';
import 'package:to_do_list_app/page/login_page.dart';
import 'package:to_do_list_app/page/mood_page.dart';
import 'package:to_do_list_app/page/notes_page.dart';
import 'package:to_do_list_app/page/pengaturan_page.dart';
import 'package:to_do_list_app/page/pengingat_page.dart';
import 'package:to_do_list_app/page/splashcreen.dart';
import 'package:to_do_list_app/page/user_page.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/pengaturan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TugasViewModel()),
        ChangeNotifierProvider(create: (context) => KategoriViewModel()),
        ChangeNotifierProvider(create: (context) => LabelViewmodel()),
        ChangeNotifierProvider(create: (context) => PengaturanViewmodel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/': (context) => Splashcreen(),
        '/home': (context) => HomePage(),
        '/pengguna': (context) => UserPage(),
        '/kategori': (context) => KategoriPage(),
        '/pengingat': (context) => PengingatPage(),
        '/favorit': (context) => FavoritPage(),
        '/arsip': (context) => ArsipPage(),
        '/label': (context) => LabelPage(),
        '/pengaturan': (context) => PengaturanPage(),
        '/login': (context) => LoginPage(),
        '/kalender': (context) => KalenderPage(),
        '/mood': (context) => MoodPage(),
        '/pikiran': (context) => KotakPikiranPage(),
        '/catatan': (context) => NotesPage(),
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:to_do_list_app/page/mood_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Mood Page Preview',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MoodPage(), // ⬅️ tampilkan langsung MoodPage
//     );
//   }
// }
