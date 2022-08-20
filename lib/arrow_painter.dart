import 'dart:math';

import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.shade700
      ..strokeWidth = 2;
    final p1 = Offset(size.width / 2, 0);
    final p2 = Offset(size.width / 2, size.height * 0.99);
    canvas.drawLine(
      p1,
      p2,
      paint,
    );
    const arrowSize = 20;
    const arrowAngle = 35 * pi / 180;
    const angle = pi / 2;
    Path path = Path();
    path.moveTo(p2.dx - arrowSize * cos(angle - arrowAngle),
        p2.dy - arrowSize * sin(angle - arrowAngle));
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p2.dx - arrowSize * cos(angle + arrowAngle),
        p2.dy - arrowSize * sin(angle + arrowAngle));
    path.close();
    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
