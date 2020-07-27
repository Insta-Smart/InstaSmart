// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:image/image.dart' as imglib;

Uint8List overlayImages(Uint8List imgTop, Uint8List imgBottom) {
  int dstWidth = 1080;
  imglib.Image image = imglib.Image(dstWidth, dstWidth);
  imglib.Image dst = imglib.decodeImage(imgBottom);
  imglib.Image src = imglib.decodeImage(imgTop);

  dst = imglib.copyResizeCropSquare(dst, dstWidth);
  src = imglib.copyResizeCropSquare(src, dstWidth - 100);
  int srcWidth = src.width.floor().toInt();
  dstWidth = dst.width.floor().toInt();
  int dstPostion = ((dst.width - src.width) / 2).toInt();
  var overlayedImage = imglib.copyInto(image, src,
      dstX: dstPostion,
      dstY: dstPostion,
      srcH: srcWidth,
      srcW: srcWidth,
      srcX: 0,
      srcY: 0,
      blend: true);
  var finalImage = imglib.copyInto(overlayedImage, dst,
      dstX: 0,
      dstY: 0,
      srcH: dstWidth,
      srcW: dstWidth,
      srcX: 0,
      srcY: 0,
      blend: true);
  return imglib.encodePng(overlayedImage);
}
