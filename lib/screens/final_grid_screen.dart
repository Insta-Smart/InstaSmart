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
import 'package:instasmart/models/splitImage.dart';
import 'package:instasmart/screens/preview_screen.dart';
import 'package:instasmart/widgets/split_grid.dart';
import 'package:instasmart/widgets/gridline_painter.dart';
import 'package:instasmart/models/widget_to_image.dart';

class FinalGrid extends StatefulWidget {
  Uint8List imgBytes;
  FinalGrid(this.imgBytes);
  @override
  _FinalGridState createState() => _FinalGridState();
}

class _FinalGridState extends State<FinalGrid> {
  var firebaseStorage = FirebaseImageStorage();
  var size = SizeConfig();
  bool addingToPreview = false;
  double splitScale = 1;
  int splitType = 3;
  Uint8List imgBytes;
  List<bool> _selected = [false, false, true];
  List<CustomPainter> painters = [
    Grid3Painter(),
    Grid6Painter(),
    Grid9Painter()
  ];
  CustomPainter gridPainter = Grid9Painter();

  @override
  Widget build(BuildContext context) {
    imgBytes = widget.imgBytes;
    GlobalKey gridKey = new GlobalKey();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SplitGrid(
                  gridPainter: gridPainter,
                  gridKey: gridKey,
                  splitScale: splitScale,
                  imgBytes: imgBytes),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Center(
              child: ToggleButtons(
                children: <Widget>[
                  Icon(Icons.grid_on),
                  Icon(Icons.grid_on),
                  Icon(Icons.grid_on),
                ],
                isSelected: _selected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                    buttonIndex < _selected.length;
                    buttonIndex++) {
                      if (buttonIndex == index) {
                        _selected[buttonIndex] = true;
                      } else {
                        _selected[buttonIndex] = false;
                      }
                    }
                    gridPainter = painters[index];
                    splitType = index + 1;
                    splitScale = index == 0 ? 3 : index == 1 ? 1.5 : 1;
                  });
                },
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TemplateButton(
                      iconType: Icons.file_download,
                      title: 'Save to Gallery',
                      ontap: () async {
                        Uint8List capturedImage =
                            await captureWidgetImage(gridKey);
                        List<Uint8List> splitImages = await splitImage(
                            imgBytes: capturedImage,
                            verticalPieceCount: splitType,
                            horizontalPieceCount: 3);
                        await saveImages(splitImages);
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
                          Uint8List capturedImage =
                              await captureWidgetImage(gridKey);
                          List<Uint8List> splitImages = await splitImage(
                              imgBytes: capturedImage,
                              verticalPieceCount: splitType,
                              horizontalPieceCount: 3);
                          await firebaseStorage
                              .uploadByteImage(images: splitImages)
                              .then((imageUrls) => firebaseStorage
                                  .mergeImageUrls(imageUrls.reversed.toList()));
                          Navigator.pop(context);
//                    Navigator.pushNamed(context, PreviewScreen.routeName);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        index: 1,
                                      )));
                        }),

                  ]),
            )
          ],
        ),
      ),
    );
  }
}
