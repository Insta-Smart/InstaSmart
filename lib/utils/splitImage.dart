// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:image/image.dart' as imglib;

List<Uint8List> splitImage(
    {List<int> imgBytes, int verticalPieceCount, int horizontalPieceCount}) {
  // convert the input image into a image from the image package
  imglib.Image image = imglib.decodeImage(imgBytes);
  final int width = (image.width / horizontalPieceCount).floor();
  final int height = (image.height / verticalPieceCount).floor();
  int x = 0;
  int y = 0;
  List<imglib.Image> imgPieces = List<imglib.Image>();

  //Split the image into the required pieces
  for (int i = 0; i < verticalPieceCount; i++) {
    for (int j = 0; j < horizontalPieceCount; j++) {
      imgPieces.add(
        imglib.copyCrop(image, x, y, width, height),
      );
      x += width;
    }
    x = 0;
    y += height;
  }

  //Convert image from image package to a flutter image (byteData)
  List<Uint8List> outputImages = List<Uint8List>();
  for (var img in imgPieces) {
    outputImages.add(imglib.encodePng(img));
  }
  return outputImages;
}
