import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/page/arsip_page.dart';
import 'package:to_do_list_app/page/detailTugas_page.dart';
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
import 'package:to_do_list_app/page/tugasKategori_page.dart';
import 'package:to_do_list_app/page/tugasLabel_page.dart';
import 'package:to_do_list_app/page/user_page.dart';
import 'package:to_do_list_app/viewmodel/auth_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/catatanPikiran_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/kategori_user_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/kategori_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/pengaturan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/theme_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugasSampingan_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/tugas_viewmodel.dart';
import 'package:to_do_list_app/viewmodel/user_viewmodel.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides(); // ✅ Tambahkan ini
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TugasViewModel()),
        ChangeNotifierProvider(create: (_) => KategoriViewModel()..fetchKategori()),
        ChangeNotifierProvider(create: (_) => KategoriUserViewModel()..fetchKategoriUser()),
        ChangeNotifierProvider(create: (context) => LabelViewModel()),
        ChangeNotifierProvider(create: (context) => PengaturanViewmodel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => ThemeViewModel()),
        // ChangeNotifierProvider(create: (context) => TugasSampinganViewModel()),
        ChangeNotifierProvider(create: (context) => CatatanPikiranViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()..fetchUser()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeVM, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'To Do List App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeVM.themeMode,
          initialRoute: '/login',
          routes: {
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
            '/catatanPikiran': (context) => NotesPage(),
            '/detailTugas': (context) => DetailTugasPage(),
            '/tugasKategori': (context) => TugaskategoriPage(),
            '/tugasLabel': (context) => TugaslabelPage(),
          },
        );
      },
    );
  }
}

// BATAS


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


// BATAS


// import 'package:flutter/material.dart';
// import 'package:to_do_list_app/database_helper.dart';
// import 'package:to_do_list_app/model/note.dart';

//    void main() {
//      runApp(MyApp());
//    }

//    class MyApp extends StatelessWidget {
//      @override
//      Widget build(BuildContext context) {
//        return MaterialApp(
//          title: 'Flutter SQLite CRUD',
//          theme: ThemeData(
//            primarySwatch: Colors.blue,
//          ),
//          home: MyHomePage(),
//        );
//      }
//    }

//    class MyHomePage extends StatefulWidget {
//      @override
//      _MyHomePageState createState() => _MyHomePageState();
//    }

//    class _MyHomePageState extends State<MyHomePage> {
//      final dbHelper = DatabaseHelper.instance;
//      List<Note> _notes = [];

//      @override
//      void initState() {
//        super.initState();
//        _loadNotes();
//      }

//      void _loadNotes() async {
//        List<Note> notes = await dbHelper.getAllNotes();
//        setState(() {
//          _notes = notes;
//        });
//      }

//      void _addNote() async {
//        Note newNote = Note(
//          name: 'New Note',
//          description: 'Description',
//        );
//        int id = await dbHelper.insert(newNote);
//        setState(() {
//          newNote.id = id;
//          _notes.add(newNote);
//        });
//      }

//      void _updateNote(int index) async {
//        Note updatedNote = Note(
//          id: _notes[index].id,
//          name: 'Updated Note',
//          description: 'Updated Description',
//        );
//        await dbHelper.update(updatedNote);
//        setState(() {
//          _notes[index] = updatedNote;
//        });
//      }

//      void _deleteNote(int index) async {
//        await dbHelper.delete(_notes[index].id!);
//        setState(() {
//          _notes.removeAt(index);
//        });
//      }

//      @override
//      Widget build(BuildContext context) {
//        return Scaffold(
//          appBar: AppBar(
//            title: Text('Flutter SQLite CRUD'),
//          ),
//          body: ListView.builder(
//            itemCount: _notes.length,
//            itemBuilder: (context, index) {
//              return ListTile(
//                title: Text(_notes[index].name),
//                subtitle: Text(_notes[index].description),
//                trailing: Row(
//                  mainAxisSize: MainAxisSize.min,
//                  children: [
//                    IconButton(
//                      icon: Icon(Icons.edit),
//                      onPressed: () {
//                        _updateNote(index);
//                      },
//                    ),
//                    IconButton

// (
//                      icon: Icon(Icons.delete),
//                      onPressed: () {
//                        _deleteNote(index);
//                      },
//                    ),
//                  ],
//                ),
//              );
//            },
//          ),
//          floatingActionButton: FloatingActionButton(
//            child: Icon(Icons.add),
//            onPressed: () {
//              _addNote();
//            },
//          ),
//        );
//      }
//    }