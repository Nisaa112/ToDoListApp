import 'dart:async';

import 'package:flutter/material.dart';

class Splashcreen extends StatefulWidget {
  const Splashcreen({super.key});

  @override
  State<Splashcreen> createState() => _SplashcreenState();
}

class _SplashcreenState extends State<Splashcreen> {
  @override
  void initState() {
    super.initState();

    // delay selama 3 detik
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF485F88),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/logo1.png', width: 20, height: 20,),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}