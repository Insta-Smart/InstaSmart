import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'reorderableGrid.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

//https://medium.com/flutter-community/export-your-widget-to-image-with-flutter-dc7ecfa6bafb reference

class OverlayImagesFunctions extends StatefulWidget {
  static const routeName = '/overlayImagesFunction';
  @override
  _OverlayImagesFunctionsState createState() =>
      new _OverlayImagesFunctionsState();
}

class _OverlayImagesFunctionsState extends State<OverlayImagesFunctions> {
  GlobalKey _globalKey = new GlobalKey();
  bool inside = false;
  Uint8List imageInMemory;
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("testing_overlay");
  String _downloadurl;
  bool askedToCreate = false;

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
                  });
                },
              ),
              Expanded(
                flex: 1,
                child: askedToCreate ? convertToImage() : Container(),
              ),
              imageInMemory == null
                  ? Container()
                  : Container(
                      child: Image.memory(imageInMemory),
                      margin: EdgeInsets.all(10)),
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

  Widget convertToImage() {
    //this function will convert the widget inside RepaintBoundary to an image
    return Column(
      children: <Widget>[
        RepaintBoundary(
          key: _globalKey,
          //child converted to img
          child: Container(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                      width: 200,
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_1.png?alt=media&token=09b3e728-6d01-4c07-a3c5-dbea4b0f9781")),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_2.png?alt=media&token=7966740e-f042-4e7a-9ea2-1fcb561b5a8a")),
              ],
            ),
          ),
        ),
        RaisedButton(
          child: Text('capture Image'),
          onPressed: _capturePng,
        ),
      ],
    );
  }
}
