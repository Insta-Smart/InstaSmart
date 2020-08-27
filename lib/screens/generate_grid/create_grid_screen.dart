// Dart imports:
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instasmart/components/custom_dialog_widget.dart';
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/components/template_button.dart';
import 'package:instasmart/components/tip_widgets.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/screens/generate_grid/post_order_screen.dart';
import 'package:instasmart/services/firebase_image_storage.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/utils/overlayImages.dart';
import 'package:instasmart/utils/save_images.dart';
import 'package:instasmart/utils/size_config.dart';
import 'package:instasmart/utils/splitImage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:reorderables/reorderables.dart';

import 'components/grid_frame.dart';

class CreateScreen extends StatefulWidget {
  static const routeName = '/create_grid';
  CreateScreen(this.frameUrl, this.index, this.user);
  var frameUrl;
  int index;
  final User user;
  @override
  _CreateScreenState createState() => new _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var firebaseStorage = FirebaseImageStorage();
  List<Asset> images = List<Asset>();
  List imageBytes;
  bool addedImgs = false;
  bool finished = false;
  bool loader = false;

  @override
  void initState() {
    super.initState();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      images.insert(newIndex, images.removeAt(oldIndex));
    });
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  Widget buildGridView() {
    return Container(
      child: ReorderableWrap(
        minMainAxisCount: 3,
        onReorder: _onReorder,
        padding: EdgeInsets.all(0),
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Container(
            height: SizeConfig.screenWidth / 3,
            width: SizeConfig.screenWidth / 3,
            child: FittedBox(
              fit: BoxFit.fill,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 19),
                child: AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#b37df0",
          actionBarTitle: "Select Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      print('error in multi-image-picker: ${e}');
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      images.length == 0 ? null : addedImgs = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    SizeConfig().init(context);
    GlobalKey _globalKey = new GlobalKey();
    return new Scaffold(
      appBar: PageTopBar(
        title: 'Create Grid',
        appBar: AppBar(),
        widgets: <Widget>[
          finished
              ? Container(
                  width: SizeConfig.blockSizeHorizontal * 30,
                  height: SizeConfig.blockSizeVertical * 8,
                  child: TemplateButton(
                    iconType: CupertinoIcons.pencil,
                    title: ' Edit',
                    ontap: () async {
                      setState(() {
                        finished = false;
                      });
                    },
                  ),
                )
              : Container(
                  width: SizeConfig.blockSizeHorizontal * 30,
                  height: SizeConfig.blockSizeVertical * 8,
                )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
        child: Container(
          child: Column(children: <Widget>[
            Container(
              height: SizeConfig.screenWidth,
              child: RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: <Widget>[
                    GridFrameInitial(
                      frameUrl: widget.frameUrl,
                      index: widget.index,
                    ),
                    buildGridView(),
                    finished
                        ? GridFrameFinal(
                            frameUrl: widget.frameUrl,
                            index: widget.index,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, SizeConfig.blockSizeVertical * 1, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          !finished
                              ? Column(
                                  children: <Widget>[
                                    TemplateButton(
                                        title: ' 1. Add Your Photos',
                                        iconType: Icons.camera,
                                        ontap: () {
                                          loadAssets();
                                        }),
                                  ],
                                )
                              : Container(),
                          addedImgs && !finished
                              ? TemplateButton(
                                  title: ' 2. Finish',
                                  iconType: Icons.check_circle_outline,
                                  color: Colors.lightGreen,
                                  ontap: () async {
                                    setState(() {
                                      finished = true;
                                    });
                                    var srcBytesList = List();
                                    for (var img in images) {
                                      var bytes = await img.getByteData();
                                      var srcBytes = bytes.buffer.asUint8List();
                                      srcBytesList.add(srcBytes);
                                    }
                                  })
                              : Container(),
                        ],
                      ),
                      !finished
                          ? TipTextWidget(
                              tipBody: !addedImgs
                                  ? 'To create a 1x3 or 2x3 grid, add just 3 or 6 photos.'
                                  : 'Press & hold photos to rearrange them.',
                            )
                          : Container(),
                    ],
                  ),
                  finished
                      ? Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                TemplateButton(
                                  iconType: Icons.file_download,
                                  title: 'Save to Gallery',
                                  ontap: () async {
                                    await _requestPermission();
                                    bool functionDone = false;

                                    pr.style(
                                      message: 'Saving your grid...',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      messageTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      progressWidget: Container(),
//                                      SpinKitFadingGrid(
//                                        size: 30,
//                                        color: Constants.lightPurple,
                                      // ),
                                      elevation: 10.0,
                                    );
                                    pr.show();

                                    Future.delayed(
                                        const Duration(milliseconds: 3000), () {
                                      if (!functionDone) {
                                        pr.update(
                                            progress: 50.0,
                                            message: 'Please wait...');

//                                        pr.hide();
//                                        pr.style(
//                                          message:
//                                              'Saving in HD. Please wait...',
//                                          borderRadius: 10.0,
//                                          backgroundColor: Colors.white,
//                                          progressWidget: SpinKitFadingGrid(
//                                            size: 30,
//                                            color: Constants.lightPurple,
//                                          ),
//                                          elevation: 10.0,
//                                        );
//                                        pr.show();
                                      }
                                    });

                                    List<Uint8List> srcBytesList = List();
                                    List<Uint8List> genImages = List();

                                    for (var img in images) {
                                      var byteData = await img.getByteData();
                                      srcBytesList
                                          .add(byteData.buffer.asUint8List());
                                    }
//
                                    var dstBytes = await networkImageToByte(
                                        widget.frameUrl);

                                    var split = splitImage(
                                        imgBytes: dstBytes,
                                        verticalPieceCount: 3,
                                        horizontalPieceCount: 3);
                                    for (int i = 0;
                                        i < srcBytesList.length;
                                        i++) {
                                      genImages.add(overlayImages(
                                          srcBytesList[i], split[i]));
                                    }
                                    pr.hide();

                                    saveImages(genImages).then((value) {
                                      print(value);
                                      functionDone = true;
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialogWidget(
                                                title: 'Saved!',
                                                body:
                                                    'Images have been saved to gallery',
                                              ));
                                    });
                                  },
                                ),
                                TemplateButton(
                                  title: ' Add to My Feed',
                                  iconType: Icons.grid_on,
                                  ontap: () async {
                                    bool functionDone = false;
                                    pr.style(
                                      message: 'Adding to Feed...',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      messageTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      elevation: 10.0,
                                    );
                                    pr.show();
                                    Future.delayed(
                                        const Duration(milliseconds: 6000), () {
                                      if (!functionDone) {
                                        pr.update(
                                            progress: 50.0,
                                            message:
                                                'This takes some time. Please wait...');
                                      }
                                    });
                                    //print('running function');
                                    List<Uint8List> srcBytesList = List();
                                    List<Uint8List> genImages = List();
                                    try {
                                      for (var img in images) {
                                        var byteData = await img.getByteData();
                                        srcBytesList
                                            .add(byteData.buffer.asUint8List());
                                      }
                                      var dstBytes = await networkImageToByte(
                                          widget.frameUrl);
                                      var split = splitImage(
                                          imgBytes: dstBytes,
                                          verticalPieceCount: 3,
                                          horizontalPieceCount: 3);
                                      for (int i = 0;
                                          i < srcBytesList.length;
                                          i++) {
                                        genImages.add(overlayImages(
                                            srcBytesList[i], split[i]));
                                      }

                                      await firebaseStorage
                                          .uploadByteImage(images: genImages)
                                          .then((imageUrls) =>
                                              firebaseStorage.mergeImageUrls(
                                                  imageUrls.reversed.toList()));
                                      functionDone = true;
                                    } catch (e) {
                                      print('error in adding to grid is ${e}');
                                    }
                                    pr.hide();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialogWidget(
                                              title: functionDone
                                                  ? 'Success!'
                                                  : 'Error',
                                              body: functionDone
                                                  ? 'Images have been added to Preview'
                                                  : 'Please try again',
                                              action1: functionDone
                                                  ? () {
                                                      pushAndRemoveUntil(
                                                          context,
                                                          HomeScreen(
                                                              index: 2,
                                                              user:
                                                                  widget.user),
                                                          false);
                                                    }
                                                  : null,
                                              action1text: functionDone
                                                  ? "Go To My Feed"
                                                  : null,
                                            ));
                                  },
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                TemplateButton(
                                  iconType: FontAwesomeIcons.instagram,
                                  title: ' Post To Instagram',
//                                  color: Constants.lightPurple,
                                  ontap: () async {
                                    bool functionDone = false;
                                    pr.style(
                                      message: 'Preparing Images...',
                                      borderRadius: 10.0,
                                      messageTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                      backgroundColor: Colors.white,
//                                      SpinKitFadingGrid(
//                                        size: 30,
//                                        color: Constants.lightPurple,
//                                      ),

                                      elevation: 10.0,
                                    );
                                    pr.show();
                                    Future.delayed(
                                        const Duration(milliseconds: 6000), () {
                                      if (!functionDone) {
                                        pr.update(
                                            progress: 50.0,
                                            message:
                                                'Loading InstaSmart guide...');
                                      }
                                    });
                                    List<Uint8List> srcBytesList = List();
                                    List<Uint8List> genImages = List();

                                    for (var img in images) {
                                      var byteData = await img.getByteData();
                                      srcBytesList
                                          .add(byteData.buffer.asUint8List());
                                    }

                                    var dstBytes = await networkImageToByte(
                                        widget.frameUrl);
                                    var split = splitImage(
                                        imgBytes: dstBytes,
                                        verticalPieceCount: 3,
                                        horizontalPieceCount: 3);
                                    for (int i = 0;
                                        i < srcBytesList.length;
                                        i++) {
                                      genImages.add(overlayImages(
                                          srcBytesList[i], split[i]));
                                    } //genImages is list of Uint8List --> display this
                                    print(
                                        'genImages is $genImages'); //--> Okay till here
                                    {
                                      //result of saveImages is null. Instead, just pass list of
//
                                      pr.hide();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostOrderScreen(
                                                      genImages, widget.user)));
                                    }
                                    ;
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
