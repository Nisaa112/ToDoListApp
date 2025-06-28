import 'package:flutter/material.dart';

class CustomBottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF485F88)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);

    path.quadraticBezierTo(
      size.width * 0.40, 0,
      size.width * 0.42, 20,
    );

    path.arcToPoint(
      Offset(size.width * 0.58, 20),
      radius: Radius.circular(20),
      clockwise: false,
    );

    path.quadraticBezierTo(
      size.width * 0.60, 0,
      size.width * 0.65, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
