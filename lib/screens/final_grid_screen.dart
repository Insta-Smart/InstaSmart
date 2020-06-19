import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:instasmart/models/save_images.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/screens/preview_screen.dart';

class ImageDisplay extends StatelessWidget {
  List<Uint8List> imgBytes;
  ImageDisplay(this.imgBytes);
  var firebaseStorage = FirebaseImageStorage();
  var size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: SizeConfig.screenWidth,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(imgBytes.length, (index) {
                  return Container(
                    child: Image.memory(imgBytes[index]),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                  );
                }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Save Image'),
                color: Colors.deepPurpleAccent,
                onPressed: () async {
                  await saveImages(imgBytes);
                },
              ),
              RaisedButton(
                child: Text('Add Grid to Preview'),
                color: Colors.blueAccent,
                onPressed: () async {
                  await firebaseStorage.uploadByteImage(images: imgBytes).then(
                          (imageUrls) => firebaseStorage
                          .mergeImageUrls(imageUrls.reversed.toList()));
                  Navigator.pushNamed(context, PreviewScreen.routeName);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
