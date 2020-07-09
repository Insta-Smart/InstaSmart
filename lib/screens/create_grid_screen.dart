import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import '../constants.dart';
import 'final_grid_screen.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:instasmart/models/splitImage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'final_grid_screen.dart';
import 'frames_screen.dart';
import 'loading_screen.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:image/image.dart' as imglib;
import 'package:instasmart/models/save_images.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'home_screen.dart';
import 'preview_screen.dart';
import 'package:reorderables/reorderables.dart';
import 'package:instasmart/widgets/grid_frame.dart';
import 'package:instasmart/widgets/template_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:progress_dialog/progress_dialog.dart';

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

    final ProgressDialog pr = ProgressDialog(context);

    SizeConfig().init(context);
    GlobalKey _globalKey = new GlobalKey();
    return new Scaffold(
      appBar: PageTopBar(
        title: 'Create Grid',
        appBar: AppBar(),
        widgets: <Widget>[],
      ),
//      AppBar(
//        title: Text('Create Grid'),
//        leading: IconButton(
//          icon: Icon(Icons.keyboard_backspace),
//          onPressed: () => Navigator.pop(context),
//        ),
//      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
        child: Container(
          child: Column(children: <Widget>[
            Container(
              height: SizeConfig.screenWidth,
              //height: SizeConfig.blockSizeVertical * 60,
              child: RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: <Widget>[
                    GridFrame(widget: widget),
                    buildGridView(),
                    finished
                        ? GridFrame(
                            widget: widget,
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
                            await images.forEach((img) async {
                              var bytes = await img.getByteData();
                              var srcBytes = bytes.buffer.asUint8List();
                              srcBytesList.add(srcBytes);
                            });
//                              Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) =>
//                                            FinalGrid(srcBytesList[0]),
//                                    ),
//                                );
                          },
                        )
                      : Container(),
                  finished
                      ? TemplateButton(
                          iconType: Icons.file_download,
                          title: 'Save to Gallery',
                          ontap: () async {
                            pr.style(
                              message: 'Saving...',
                              borderRadius: 10.0,
                              backgroundColor: Colors.white,
                              progressWidget: SpinKitFadingGrid(
                                size: 30,
                                color: Colors.deepPurple,
                              ),
                              elevation: 10.0,
                            );
                            pr.show();
                            List<Uint8List> srcBytesList = List();
                            List<Uint8List> genImages = List();

                            var srcBytes = await images.forEach((img) {
                              img.getByteData().then((value) =>
                                  srcBytesList.add(value.buffer.asUint8List()));
                            });
                            var dstBytes =
                                await networkImageToByte(widget.frameUrl);
                            var split = splitImage(
                                imgBytes: dstBytes,
                                verticalPieceCount: 3,
                                horizontalPieceCount: 3);
                            for (int i = 0; i < srcBytesList.length; i++) {
                              genImages.add(
                                  overlayImages(srcBytesList[i], split[i]));
                            }
                            await saveImages(genImages);
                            pr.hide();

                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dialogType: DialogType.SUCCES,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Saved',
                              desc: 'Images have been saved to gallery',
                              btnOkOnPress: () {},
                            )..show();
                          },
                        )
                      : Container(),
                  finished
                      ? TemplateButton(
                          title: 'Add Grid to Preview',
                          iconType: Icons.grid_on,
                          ontap: () async {
                            pr.style(
                              message: 'Adding to Preview...',
                              borderRadius: 10.0,
                              backgroundColor: Colors.white,
                              progressWidget: SpinKitFadingGrid(
                                size: 30,
                                color: Colors.deepPurple,
                              ),
                              elevation: 10.0,
                            );
                            pr.show();

                            List<Uint8List> srcBytesList = List();
                            List<Uint8List> genImages = List();
                            var srcBytes = await images.forEach((img) {
                              img.getByteData().then((value) =>
                                  srcBytesList.add(value.buffer.asUint8List()));
                            });
                            var dstBytes =
                                await networkImageToByte(widget.frameUrl);
                            var split = splitImage(
                                imgBytes: dstBytes,
                                verticalPieceCount: 3,
                                horizontalPieceCount: 3);
                            for (int i = 0; i < srcBytesList.length; i++) {
                              genImages.add(
                                  overlayImages(srcBytesList[i], split[i]));
                            }

                            await firebaseStorage
                                .uploadByteImage(images: genImages)
                                .then((imageUrls) =>
                                    firebaseStorage.mergeImageUrls(
                                        imageUrls.reversed.toList()));
                            pr.hide();
                            AwesomeDialog(
                                context: context,
                                headerAnimationLoop: false,
                                dialogType: DialogType.SUCCES,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Success',
                                desc: 'Images have been added to Preview',
                                btnOkOnPress: () {},
                                btnCancelText: 'Go to Preview',
                                btnCancelColor: Colors.blueAccent,
                                btnCancelOnPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                              index: 2, user: widget.user)));
                                })
                              ..show();
                          },
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
