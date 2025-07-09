import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigasi otomatis setelah delay
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 241, 248, 1.0), // atau warna tema
      body: Center(
        child: Lottie.asset(
          'assets/img/logo1.png',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
