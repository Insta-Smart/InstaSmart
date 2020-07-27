// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/components/tip_widgets.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/services/firebase_image_storage.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/utils/size_config.dart';
import './components/reorderable_grid.dart';

class PreviewScreen extends StatefulWidget {
  static const routeName = '/preview';

  PreviewScreen({Key key}) : super(key: key);

  @override
  _PreviewScreenState createState() => new _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    super.initState();
    print('my app current user is:');
    print(MyAppState.currentUser);
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
    var firebase = Provider.of<FirebaseLoginFunctions>(context);
    SizeConfig().init(context);
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: PageTopBar(
          title: 'Plan Your Instagram Feed',
          appBar: AppBar(),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                child: ReorderableGrid(
                    firebase: firebase,
                    firebaseStorage: firebaseStorage,
                    user: MyAppState.currentUser),
              ),
              TipDialogWidget(
                alignment: Alignment.bottomLeft,
                tipText:
                    '● Long-press and drag a post to rearrange it on your feed.\n \n● Tap the camera icon to add your own photos.'
                    '\n \n● Tap a post for more options.',
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  backgroundColor: Constants.paleBlue,
                  onPressed: loadAssets,
                ),
              )
            ],
          ),
        ));
  }
}
