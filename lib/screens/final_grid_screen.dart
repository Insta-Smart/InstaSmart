import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:instasmart/models/save_images.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/screens/loading_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import '../constants.dart';
import 'create_grid_screen.dart';
import 'home_screen.dart';

class ImageDisplay extends StatelessWidget {
  List<Uint8List> imgBytes;
  ImageDisplay(this.imgBytes);
  var firebaseStorage = FirebaseImageStorage();
  var size = SizeConfig();
  bool addingToPreview = false;

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
          Center(
            child: Text('Your Finished Grid!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TemplateButton(
                  iconType: Icons.file_download,
                  title: 'Download',
                  ontap: () async {
                    await saveImages(imgBytes);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(
                                'Saved',
                                textAlign: TextAlign.center,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Color(0xDDFFFFFF),
                              elevation: 0,
                            ),
                        barrierDismissible: true);
                  },
                ),
                TemplateButton(
                  title: 'Add Grid to Preview',
                  iconType: Icons.grid_on,
                  ontap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoadingScreen()));
                    await firebaseStorage
                        .uploadByteImage(images: imgBytes)
                        .then((imageUrls) => () {
                              firebaseStorage
                                  .mergeImageUrls(imageUrls.reversed.toList());
                            });
                    Navigator.pop(context);
//                    Navigator.pushNamed(context, PreviewScreen.routeName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  index: 1,
                                )));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
