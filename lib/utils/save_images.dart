// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<List<String>> saveImages(List<Uint8List> imgBytes) async {
  List<String> filePaths = List();
  for(int i= 0; i<imgBytes.length;i++){
    try {
      String result = await ImageGallerySaver.saveImage(imgBytes[i]);
      filePaths.add(result.toString().substring(8));
      
    }
    catch (e){
      print(e.toString());
    }
  }
  print(filePaths.length);
  print(imgBytes.length);
  return filePaths;

}
