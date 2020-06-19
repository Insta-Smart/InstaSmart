import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

Future<void> saveImages(List<Uint8List> imgBytes) async {
  imgBytes.forEach((element) async{
    try {
      var result = await ImageGallerySaver.saveImage(element);
      print(result);
    }
    catch (e){
      print(e.toString());
    }
  });

}