// Dart imports:
import 'dart:typed_data';

import 'package:image/image.dart' as imglib;

Uint8List overlayImages(Uint8List imgBottom, Uint8List imgTop) {
  // Overlays imgBottom on imgTop
  int dstWidth = 1080;
  //Create a blank square image of 1080x1080
  imglib.Image image = imglib.Image(dstWidth, dstWidth);
  imglib.Image dst = imglib.decodeImage(imgTop);
  imglib.Image src = imglib.decodeImage(imgBottom);

  //Resize imgTop into a 1080x1080 image
  dst = imglib.copyResizeCropSquare(dst, dstWidth);

  //Resize imgBottom into a square image with side 300 less than imgTop
//  src = imglib.copyResize(src, width: dstWidth - 300, height: dstWidth - 300);
  if (src.width >= src.height) {
    src = imglib.copyResizeCropSquare(src, dstWidth - 300);
  } else {
    try {
      src = imglib.copyCrop(
          src, 0, src.height ~/ 20, src.width.floor(), src.width.floor());
      src = imglib.copyResize(src, width: dstWidth - 300);
    } catch (e) {
      src = imglib.copyCrop(src, 0, 0, src.width.floor(), src.width.floor());
      src = imglib.copyResize(src, width: dstWidth - 300);
    }
  }

  int srcWidth = src.width.floor().toInt();
  dstWidth = dst.width.floor().toInt();
  int dstPostion = ((dst.width - src.width) ~/ 2);

  //Overlay imgBottom on the blank image
  var overlayedImage = imglib.copyInto(image, src,
      dstX: dstPostion,
      dstY: dstPostion,
      srcH: srcWidth,
      srcW: srcWidth,
      srcX: 0,
      srcY: 0,
      blend: true);

  //Overlay imgTop on the resultant overlaayed image from above
  var finalImage = imglib.copyInto(overlayedImage, dst,
      dstX: 0,
      dstY: 0,
      srcH: dstWidth,
      srcW: dstWidth,
      srcX: 0,
      srcY: 0,
      blend: true);
  return imglib.encodePng(finalImage);
}
