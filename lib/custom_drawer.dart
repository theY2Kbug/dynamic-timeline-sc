import 'package:flutter/material.dart';

class DrawerPainter extends CustomPainter {
  final Offset offset;
  final double screenWidth;
  DrawerPainter({
    required this.offset,
    required this.screenWidth,
  });

  double getControlPointX(double width) {
    if (offset.dx == 0) {
      return 0;
    } else {
      return (screenWidth - offset.dx > width) ? width : -35;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 237, 237, 237)
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(
      size.width,
      size.height,
    );
    path.lineTo(
      0,
      size.height,
    );
    path.quadraticBezierTo(
      getControlPointX(size.width),
      offset.dy,
      0,
      0,
    );
    path.close();

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
