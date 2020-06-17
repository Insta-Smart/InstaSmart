import 'dart:typed_data';
import 'package:image/image.dart' as imgpkg;

List<Uint8List> splitImage(
    {List<int> imgBytes, int verticalPieceCount, int horizontalPieceCount}) {
  // convert the input image into a image from the image package
  imgpkg.Image image = imgpkg.decodeImage(imgBytes);
  final int width = (image.width / horizontalPieceCount).floor();
  final int height = (image.height / verticalPieceCount).floor();
  int x = 0;
  int y = 0;
  List<imgpkg.Image> imgPieces = List<imgpkg.Image>();

  //Split the image into the required pieces
  for (int i = 0; i < verticalPieceCount; i++) {
    for (int j = 0; j < horizontalPieceCount; j++) {
      imgPieces.add(
        imgpkg.copyCrop(image, x, y, width, height),
      );
      x += width;
    }
    x = 0;
    y += height;
  }

  //Convert image from image package to a flutter image (byteData)
  List<Uint8List> outputImages = List<Uint8List>();
  for (var img in imgPieces) {
    outputImages.add(imgpkg.encodePng(img));
  }
  return outputImages;
}
