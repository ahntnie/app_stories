import 'package:flutter/material.dart';

class UnderlinePainter extends CustomPainter {
  final int lines;
  final Color color;

  UnderlinePainter({required this.lines, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double lineHeight = size.height / lines;
    for (int i = 0; i < lines; i++) {
      canvas.drawLine(
        Offset(0, lineHeight * (i + 1)),
        Offset(size.width, lineHeight * (i + 1)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
