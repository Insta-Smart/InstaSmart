// Dart imports:
import 'dart:async';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as imglib;
import 'package:instasmart/components/tip_widgets.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/generate_grid/post_order_screen.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:reorderables/reorderables.dart';

// Project imports:
import 'components/grid_frame.dart';
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/components/template_button.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/services/firebase_image_storage.dart';
import 'package:instasmart/utils/save_images.dart';
import 'package:instasmart/utils/size_config.dart';
import 'package:instasmart/utils/splitImage.dart';

//TODO: app crashes after adding to preview
//TODO: automatically go to preview after adding pics otherwise the user might re-add to prevoew
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

  Widget buildGridView() {
    return ReorderableWrap(
      minMainAxisCount: 3,
      onReorder: _onReorder,
      padding: EdgeInsets.all(0),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Container(
          height: SizeConfig.screenWidth / 3,
          width: SizeConfig.screenWidth / 3,
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
            child: AssetThumb(
              asset: asset,
              width: 200,
              height: 200,
            ),
          ),
        );
      }),
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
          actionBarColor: "#FF95C5EE",
          actionBarTitle: "Select Images",
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
      images.length == 0 ? null : addedImgs = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List overlayImages(Uint8List imgTop, Uint8List imgBottom) {
      int dstWidth = 1080;
      imglib.Image image = imglib.Image(dstWidth, dstWidth);
      imglib.Image dst = imglib.decodeImage(imgBottom);
      imglib.Image src = imglib.decodeImage(imgTop);

      dst = imglib.copyResizeCropSquare(dst, dstWidth);
      src = imglib.copyResizeCropSquare(src, dstWidth - 100);
      int srcWidth = src.width.floor().toInt();
      dstWidth = dst.width.floor().toInt();
      int dstPostion = ((dst.width - src.width) / 2).toInt();
      var overlayedImage = imglib.copyInto(image, src,
          dstX: dstPostion,
          dstY: dstPostion,
          srcH: srcWidth,
          srcW: srcWidth,
          srcX: 0,
          srcY: 0,
          blend: true);
      var finalImage = imglib.copyInto(overlayedImage, dst,
          dstX: 0,
          dstY: 0,
          srcH: dstWidth,
          srcW: dstWidth,
          srcX: 0,
          srcY: 0,
          blend: true);
      return imglib.encodePng(overlayedImage);
    }

    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[],
            ),
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
                  0, SizeConfig.blockSizeVertical * 3, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          !finished
                              ? TemplateButton(
                                  title: '1. Add Your Photos',
                                  iconType: Icons.camera,
                                  ontap: () {
                                    loadAssets();
                                  })
                              : Container(),
                          addedImgs && !finished
                              ? TemplateButton(
                                  title: '2. Finish',
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
                      addedImgs && !finished
                          ? TipTextWidget(
                              tipBody:
                                  'Press & hold on each photo to rearrange them.',
                            )
                          : Container()
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
                                    bool functionDone = false;
                                    pr.style(
                                      message: 'Saving your grid...',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      progressWidget: SpinKitFadingGrid(
                                        size: 30,
                                        color: Constants.lightPurple,
                                      ),
                                      elevation: 10.0,
                                    );
                                    pr.show();

                                    Future.delayed(
                                        const Duration(milliseconds: 6000), () {
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
                                      img.getByteData().then((value) =>
                                          srcBytesList
                                              .add(value.buffer.asUint8List()));
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
                                    saveImages(genImages).then((value) {
                                      print(value);
                                      pr.hide();
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
                                  title: ' Add to My Grids',
                                  iconType: Icons.grid_on,
                                  ontap: () async {
                                    bool functionDone = false;
                                    pr.style(
                                      message: 'Adding to My Grids',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      progressWidget: SpinKitFadingGrid(
                                        size: 30,
                                        color: Constants.lightPurple,
                                      ),
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
                                        img.getByteData().then((value) =>
                                            srcBytesList.add(
                                                value.buffer.asUint8List()));
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
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HomeScreen(
                                                                      index: 2,
                                                                      user: widget
                                                                          .user)));
                                                    }
                                                  : null,
                                              action1text: functionDone
                                                  ? "Go To Preview"
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
                                  color: Constants.lightPurple,
                                  ontap: () async {
                                    bool functionDone = false;
                                    pr.style(
                                      message: 'Saving your grid...',
                                      borderRadius: 10.0,
                                      backgroundColor: Colors.white,
                                      progressWidget: SpinKitFadingGrid(
                                        size: 30,
                                        color: Constants.lightPurple,
                                      ),
                                      elevation: 10.0,
                                    );
                                    pr.show();
                                    Future.delayed(
                                        const Duration(milliseconds: 6000), () {
                                      if (!functionDone) {
                                        pr.update(
                                            progress: 50.0,
                                            message:
                                                'Loading InstaSmart guide.');
                                      }
                                    });
                                    List<Uint8List> srcBytesList = List();
                                    List<Uint8List> genImages = List();

                                    for (var img in images) {
                                      img.getByteData().then((value) =>
                                          srcBytesList
                                              .add(value.buffer.asUint8List()));
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
                                    saveImages(genImages).then((value) {
                                      print(value);
                                      functionDone = true;
                                      pr.hide();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostOrderScreen(
                                                      value, widget.user)));
                                    });
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

class CustomDialogWidget extends StatelessWidget {
  final String body, title;
  final Function action1, action2;

  final Function DialogCloseRoute;
  final String action1text, action2text;

  const CustomDialogWidget(
      {Key key,
      this.body,
      this.title,
      this.action1,
      this.action1text,
      this.action2text,
      this.action2,
      this.DialogCloseRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        backgroundColor: Colors.white.withOpacity(0.88),
        title: Text(
          title,
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        content: Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Close',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: DialogCloseRoute ??
                () {
                  Navigator.of(context).pop();
                },
          ),
          action1 == null
              ? null
              : FlatButton(
                  child: Text(
                    action1text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: action1,
                ),
          action2 == null
              ? null
              : FlatButton(
                  child: Text(
                    action2text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: action2),
        ]);
  }
}
