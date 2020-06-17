import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:save_in_gallery/save_in_gallery.dart';

class ImageDisplay extends StatelessWidget {
  List<Uint8List> imgBytes;
  ImageDisplay(this.imgBytes);

  Future<void> saveAssetImage(imgBytes) async {
    final res = await ImageSaver().saveImages(imageBytes: imgBytes);
    print(res);
    print(imgBytes.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(imgBytes.length, (index) {
          return Container(
            child: Image.memory(imgBytes[index]),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          );
        }),
      )),
      floatingActionButton: FloatingActionButton(
        child: Text('Save Image'),
        backgroundColor: Colors.teal,
        onPressed: () async {
          await saveAssetImage(imgBytes);
        },
      ),
    );
  }
}
