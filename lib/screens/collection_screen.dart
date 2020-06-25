import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/frames_firebase_functions.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/create_grid_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import 'package:instasmart/widgets/reorderableCollection.dart';
import 'package:instasmart/widgets/reorderableGrid.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:instasmart/widgets/frame_widget.dart';
import '../constants.dart';
import '../main.dart';
import 'frames_screen.dart';

class CollectionScreen extends StatefulWidget {
  static const routeName = '/collection';
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
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
    return SafeArea(
      child: Container(
        height: SizeConfig.blockSizeVertical * 78,
        padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 5, 0, 0),
        child: Card(
          elevation: 10,
          child: Container(
            child: ReorderableCollection(
                firebase: firebase, firebaseStorage: firebaseStorage),
          ),
        ),
      ),
    );
  }
}
