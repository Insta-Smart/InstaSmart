import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../widgets/reorderableGrid.dart';
import 'package:instasmart/models/utility.dart';

class PreviewScreen extends StatefulWidget {
  static const routeName = '/preview';
  @override
  _PreviewScreenState createState() => new _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "InstaSmart",
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
    return new MaterialApp(
      home: new Scaffold(

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: ReorderableGrid(images),
            ),
            FloatingActionButton(child: Icon(Icons.add_a_photo),onPressed: loadAssets,),

          ],
        ),
      ),
    );
  }
}


