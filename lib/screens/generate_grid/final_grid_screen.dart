//// Dart imports:
//import 'dart:typed_data';
//
//// Flutter imports:
//import 'package:flutter/material.dart';
//
//// Project imports:
//import '../../constants.dart';
//import 'create_grid_screen.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/components/template_button.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/screens/preview_screen/preview_screen.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/screens/preview_screen/preview_screen.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/services/firebase_image_storage.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/utils/save_images.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/utils/size_config.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/utils/splitImage.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/utils/widget_to_image.dart';
//import 'package:instasmart/components/page_top_bar.dart';
//import 'package:instasmart/screens/HomeScreen.dart';
//import 'package:instasmart/screens/frames_screen/frames_screen.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/components/loading_screen.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/screens/generate_grid/components/gridline_painter.dart';
//import 'file:///C:/Users/noelm/Documents/Android/InstaSmart/lib/screens/generate_grid/components/split_grid.dart';
//
//class FinalGrid extends StatefulWidget {
//  Uint8List imgBytes;
//  FinalGrid(this.imgBytes);
//  @override
//  _FinalGridState createState() => _FinalGridState();
//}
//
//class _FinalGridState extends State<FinalGrid> {
//  var firebaseStorage = FirebaseImageStorage();
//  var size = SizeConfig();
//  bool addingToPreview = false;
//  double splitScale = 1;
//  int splitType = 3;
//  Uint8List imgBytes;
//  List<bool> _selected = [false, false, true];
//  List<CustomPainter> painters = [
//    Grid3Painter(),
//    Grid6Painter(),
//    Grid9Painter()
//  ];
//  CustomPainter gridPainter = Grid9Painter();
//
//  @override
//  Widget build(BuildContext context) {
//    imgBytes = widget.imgBytes;
//    GlobalKey gridKey = new GlobalKey();
//
//    return Scaffold(
//      appBar: PageTopBar(
//        title: 'Finish Grid',
//        appBar: AppBar(),
//        widgets: <Widget>[],
//      ),
//      body: SafeArea(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Center(
//              child: SplitGrid(
//                  gridPainter: gridPainter,
//                  gridKey: gridKey,
//                  splitScale: splitScale,
//                  imgBytes: imgBytes),
//            ),
//            SizedBox(
//              height: SizeConfig.blockSizeVertical * 2,
//            ),
//            Center(
//              child: ToggleButtons(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: ThreeRowWidget(),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        ThreeRowWidget(),
//                        ThreeRowWidget(),
//                      ],
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Column(
//                      children: <Widget>[
//                        ThreeRowWidget(),
//                        ThreeRowWidget(),
//                        ThreeRowWidget()
//                      ],
//                    ),
//                  ),
//                ],
//                isSelected: _selected,
//                onPressed: (int index) {
//                  setState(() {
//                    for (int buttonIndex = 0;
//                        buttonIndex < _selected.length;
//                        buttonIndex++) {
//                      if (buttonIndex == index) {
//                        _selected[buttonIndex] = true;
//                      } else {
//                        _selected[buttonIndex] = false;
//                      }
//                    }
//                    gridPainter = painters[index];
//                    splitType = index + 1;
//                    splitScale = index == 0 ? 3 : index == 1 ? 1.5 : 1;
//                  });
//                },
//              ),
//            ),
//            SizedBox(
//              height: SizeConfig.blockSizeVertical * 2,
//            ),
//            Container(
//              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//              child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//
//                    TemplateButton(
//                      iconType: Icons.file_download,
//                      title: 'Save to Gallery',
//                      ontap: () async {
//                        Uint8List capturedImage =
//                            await captureWidgetImage(gridKey);
//                        List<Uint8List> splitImages = await splitImage(
//                            imgBytes: capturedImage,
//                            verticalPieceCount: splitType,
//                            horizontalPieceCount: 3);
//                        await saveImages(splitImages);
//                        showDialog(
//                            context: context,
//                            builder: (_) => AlertDialog(
//                                  title: Text(
//                                    'Saved',
//                                    textAlign: TextAlign.center,
//                                  ),
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(15),
//                                  ),
//                                  backgroundColor: Color(0xDDFFFFFF),
//                                  elevation: 0,
//                                ),
//                            barrierDismissible: true);
//                      },
//                    ),
//                    TemplateButton(
//                        title: 'Add Grid to Preview',
//                        iconType: Icons.grid_on,
//                        ontap: () async {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => LoadingScreen()));
//                          Uint8List capturedImage =
//                              await captureWidgetImage(gridKey);
//                          List<Uint8List> splitImages = await splitImage(
//                              imgBytes: capturedImage,
//                              verticalPieceCount: splitType,
//                              horizontalPieceCount: 3);
//                          await firebaseStorage
//                              .uploadByteImage(images: splitImages)
//                              .then((imageUrls) => firebaseStorage
//                                  .mergeImageUrls(imageUrls.reversed.toList()));
//                          Navigator.pop(context);
////                    Navigator.pushNamed(context, PreviewScreen.routeName);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => HomeScreen(
//                                        index: 1,
//                                      )));
//                        }),
//
//                  ]),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class ThreeRowWidget extends StatelessWidget {
//  const ThreeRowWidget({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      children: <Widget>[
//        Icon(
//          Icons.crop_square,
//          size: 13,
//        ),
//        Icon(
//          Icons.crop_square,
//          size: 13,
//        ),
//        Icon(
//          Icons.crop_square,
//          size: 13,
//        ),
//      ],
//    );
//  }
//}
