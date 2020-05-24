import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/frames_screen.dart';
import 'package:instasmart/screens/home_screen.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:instasmart/widgets/reorderableGrid.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import 'overlaying_images_functions.dart';

//https://medium.com/flutter-community/export-your-widget-to-image-with-flutter-dc7ecfa6bafb reference

class CreateScreen extends StatefulWidget {
  static const routeName = '/create';

  final Image passedOver; //replace with chosen frame later

  CreateScreen({Key key, this.passedOver}) : super(key: key);

  @override
  _CreateScreenState createState() => new _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<Asset> images = List<Asset>(); //holds imgs
  String _error = 'No Error Detected';
  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  bool askedToCreate = false;
  static Uint8List imageInMemory;

  _CreateScreenState() {}
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List(); //image information
      //var bs64 = base64Encode(pngBytes); //image information
      //print(pngBytes);
      //   print("SEE HERE FINAL RESULT ${bs64}");
      print("png est fini");
      setState(() {});
      imageInMemory = pngBytes;
      inside = false;
    } catch (e) {
      print("error is ${e}");
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#A397EF",
          actionBarTitle: "Select 9 photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                "Create Your Grid",
                style: (TextStyle(fontSize: 45.0)),
              ),
            ),
            Row(
              children: <Widget>[
                widget.passedOver != null
                    ? addFrameButton()
                    : Stack(
                        children: <Widget>[
                          Container(child: Constants.sampleFrame),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Constants.buttonRadius),
                                color: Constants.paleBlue.withOpacity(0.8),
                              ),
                              child: Text(
                                "   1. Chosen frame   ",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Constants.buttonRadius),
                  ),
                  child: Text(
                    "2. Upload Image",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Constants.paleBlue,
                  onPressed: loadAssets,
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: ReorderableGrid(images),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.buttonRadius),
              ),
              child: Text(
                "3. Next",
                style: TextStyle(color: Colors.white),
              ),
              color: Constants.paleBlue,
              onPressed: () {
                setState(() {
                  askedToCreate = true;
//                  Navigator.of(context).push(PageRouteBuilder(
//                      opaque: false,
//                      pageBuilder: (BuildContext context, _, __) =>
//                          PopupOverlayedScreen(
//                              frameChosen: Constants.sampleFrame,
//                              userPhotoChosen: Constants.sampleUserPhoto)));
                });
                //add dialog button if selection criterias not met
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget convertToImage() {
    return Column(
      children: <Widget>[
        RepaintBoundary(
            key: _globalKey, child: Container(child: Text("Hello World"))),
        RaisedButton(
          child: Text('capture Image'),
          onPressed: _capturePng,
        ),
      ],
    );
  }

  Widget addFrameButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.buttonRadius),
      ),
      child: Text(
        "Choose A Frame",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pushNamed(context, HomeScreen.routeName);
      },
      color: Constants.paleBlue,
    );
  }
}
