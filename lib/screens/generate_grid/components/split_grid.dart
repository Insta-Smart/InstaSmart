// Dart imports:
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:photo_view/photo_view.dart';

class SplitGrid extends StatelessWidget {
  const SplitGrid({
    Key key,
    @required this.gridPainter,
    @required this.gridKey,
    @required this.splitScale,
    @required this.imgBytes,
  }) : super(key: key);

  final CustomPainter gridPainter;
  final GlobalKey<State<StatefulWidget>> gridKey;
  final double splitScale;
  final Uint8List imgBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        foregroundPainter: gridPainter,
        child: RepaintBoundary(
          key: gridKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / splitScale,
            child: PhotoView.customChild(
              backgroundDecoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Image.memory(
                imgBytes,
                fit: BoxFit.cover,
              ),
              initialScale: 1.0,
              minScale: 1.0,
              maxScale: 3.0,
            ),
          ),
        ),
      ),
    );
  }
}
