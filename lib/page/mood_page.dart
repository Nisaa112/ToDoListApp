import 'package:flutter/material.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 248, 1.0),
      body: Stack(
        children: [
          // ⬇️ Gambar pattern dengan opacity
          Opacity(
            opacity: 0.2, // transparansi gambar pattern (0.0 - 1.0)
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img/pattern.png"),
                  repeat: ImageRepeat.repeat,
                  scale: 3,
                  fit: BoxFit.none,
                ),
              ),
            ),
          ),

          // ⬇️ Konten halaman (kosong sekarang, bisa isi Column nanti)
          SafeArea(
            child: Container(
              // padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Mood Page",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF485F88),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}