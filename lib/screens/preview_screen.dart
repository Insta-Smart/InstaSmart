import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/models/size_config.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:reorderables/reorderables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'frames_screen.dart';
import 'reminder_create_form.dart';
import 'package:instasmart/widgets/reorderableGrid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreviewScreen extends StatefulWidget {
  static const routeName = '/preview';
  @override
  _PreviewScreenState createState() => new _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    super.initState();
  }

  var firebaseStorage = FirebaseImageStorage();

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

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
      await firebaseStorage
          .uploadAssetImage(assets: resultList)
          .then((imageUrls) => firebaseStorage.mergeImageUrls(imageUrls));
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var firebase = Provider.of<FirebaseFunctions>(context);
    SizeConfig().init(context);
    return new Scaffold(
//        appBar: PageTopBar(
//          title: 'Plan Your Feed',
//          appBar: AppBar(),
//        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Card(
              elevation: 10,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ReorderableGrid(
                        firebase: firebase, firebaseStorage: firebaseStorage),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          backgroundColor: Constants.paleBlue,
          onPressed: loadAssets,
        ));
  }
}
