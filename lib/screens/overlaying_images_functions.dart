// Dart imports:
import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:instasmart/constants.dart';

//https://medium.com/flutter-community/export-your-widget-to-image-with-flutter-dc7ecfa6bafb reference

class OverlayImagesFunctions extends StatefulWidget {
  static const routeName = '/overlayImagesFunction';
  @override
  _OverlayImagesFunctionsState createState() =>
      new _OverlayImagesFunctionsState();
}

class _OverlayImagesFunctionsState extends State<OverlayImagesFunctions> {
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("testing_overlay");
  String _downloadurl;
  bool askedToCreate = false;
  static Uint8List imageInMemory;

  @override
  void initState() {
    super.initState();
  }

  Future setDownloadUrl(int index) async {
    //downloads image from storage, based on index [files named as sample_index
    // to directly display this image, use Image.network(_downloadurl)
    try {
      String downloadAddress =
          await _reference.child("sample_${index}.png").getDownloadURL();
      print(downloadAddress);
      setState(() {
        _downloadurl = downloadAddress;
        print(_downloadurl);
      });
    } catch (e) {
      print(e);
    }
  }

  //DOWNLOADING IMAGE CREATED
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeContent(Uint8List imageToBeSaved) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsBytes(imageToBeSaved);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_1.png?alt=media&token=09b3e728-6d01-4c07-a3c5-dbea4b0f9781")),
                  Expanded(
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_2.png?alt=media&token=7966740e-f042-4e7a-9ea2-1fcb561b5a8a")),
                ],
              ),
              RaisedButton(
                child: Text("Create Overlay"),
                onPressed: () {
                  setState(() {
                    askedToCreate = true;
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            PopupOverlayedScreen()));
                  });
                },
              ),
              imageInMemory == null
                  ? Container()
                  : Expanded(child: Image.memory(imageInMemory)),
              imageInMemory == null
                  ? Container()
                  : RaisedButton(
                      child: Text("Save to phone"),
                      onPressed: () {
                        writeContent(imageInMemory);
                        print(imageInMemory);
                      },
                    ),
              RaisedButton(
                child: Text("Click to get url of user photo"),
                onPressed: () {
                  setDownloadUrl(1);
                },
              ),
              RaisedButton(
                child: Text("Click to get url of frame photo"),
                onPressed: () {
                  setDownloadUrl(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopupOverlayedScreen extends StatelessWidget {
  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  Uint8List imageInMemory;
  final frameChosen;
  final userPhotoChosen;

  PopupOverlayedScreen(
      {Key key, @required this.frameChosen, @required this.userPhotoChosen})
      : super(key: key);

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
      imageInMemory = pngBytes;
      print(imageInMemory);
      _OverlayImagesFunctionsState.imageInMemory = imageInMemory;
      inside = false;
    } catch (e) {
      print("error is ${e}");
    }
  }

  Widget convertToImage(Image frameChosen, Image userPhotoChosen) {
    //this function will convert the widget inside RepaintBoundary to an image
    // when the button inside this widget is pressed
    return Column(
      children: <Widget>[
        RepaintBoundary(
          key: _globalKey, //from outside
          //child converted to img
          child: Container(
            child: Stack(
              children: <Widget>[
                Center(
                    child: Container(
                  width: 200,
                  child: userPhotoChosen,
                )),
                Container(
                  alignment: Alignment.center,
                  child: frameChosen,
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          child: Text('capture Image'),
          onPressed: _capturePng, //from outside
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.5),
      body: Column(
        children: <Widget>[
          convertToImage(frameChosen, userPhotoChosen),
          RaisedButton(
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
