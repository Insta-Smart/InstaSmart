import 'package:flutter/material.dart';

class Grid9Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1;

    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );


    canvas.drawLine(
      Offset(0, size.height / 3*2),
      Offset(size.width, size.height / 3*2),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3 , size.height ),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3*2, 0),
      Offset(size.width / 3*2 , size.height ),
      paint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Grid6Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1;

    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, 0),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3 , size.height ),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3*2, 0),
      Offset(size.width / 3*2 , size.height ),
      paint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Grid3Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 1;

    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, 0),
      paint,
    );


    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3 , size.height ),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 3*2, 0),
      Offset(size.width / 3*2 , size.height ),
      paint,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}