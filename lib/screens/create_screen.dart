import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../widgets/reorderableGrid.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

//https://medium.com/flutter-community/export-your-widget-to-image-with-flutter-dc7ecfa6bafb reference

class CreateScreen extends StatefulWidget {
  static const routeName = '/create';
  @override
  _CreateScreenState createState() => new _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<Asset> images = List<Asset>(); //holds imgs
  String _error = 'No Error Detected';
  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  Uint8List imageInMemory;

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
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text("Add Images"),
                color: Constants.paleBlue,
                onPressed: loadAssets,
              ),
            ),
            Expanded(
              flex: 1,
              child: ReorderableGrid(images),
            ),
            Expanded(
              flex: 1,
              child: convertToImage(),
            ),
            imageInMemory == null
                ? Container()
                : Container(
                    child: Image.memory(imageInMemory),
                    margin: EdgeInsets.all(10)),
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
}
