import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/page/home_page.dart';
import 'package:to_do_list_app/page/kategori_page.dart';
import 'package:to_do_list_app/page/user_page.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TugasViewModel()),
        ChangeNotifierProvider(create: (context) => KategoriViewModel()), // TAMBAHKAN ini kalau belum
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
        '/home': (context) => HomePage(),
        '/pengguna': (context) => UserPage(),
        '/kategori': (context) => KategoriPage(),
      },
    );
  }
}
