// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<List<String>> saveImages(List<Uint8List> imgBytes) async {
  print('save images $imgBytes');
  List<String> filePaths = List();
  for (int i = 0; i < imgBytes.length; i++) {
    try {
      var result = await ImageGallerySaver.saveImage(imgBytes[i]).then((value) {
        print('value here is: $value');
      });
      print('result: $result'); //returns true/false in ios
      filePaths.add(result.toString().substring(8));
      print('filepaths: filePaths');
    } catch (e) {
      print(e.toString());
    }
  }
  print(filePaths.length);
  print(imgBytes.length);
  return filePaths;
}
