// Dart imports:
import 'dart:typed_data';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

Future<Uint8List> captureWidgetImage(GlobalKey key) async {
  try {
    //print('inside');
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 4.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List pngBytes = byteData.buffer.asUint8List();
    print("converted image to widget");
    return pngBytes;
  } catch (e) {
    print(e.toString());
  }
  return null;
}
