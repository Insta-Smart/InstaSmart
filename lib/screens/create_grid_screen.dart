import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'final_grid_screen.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:instasmart/models/widget_to_image.dart';
import 'package:instasmart/models/splitImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'final_grid_screen.dart';
import 'frames_screen.dart';
import 'loading_screen.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'dart:ui' as ui;
import 'dart:async';


class CreateScreen extends StatefulWidget {
  static const routeName = '/create_grid';
  CreateScreen(this.frameUrl, this.index);
  var frameUrl;
  int index;
  @override
  _CreateScreenState createState() => new _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<Asset> images = List<Asset>();
  List imageBytes;
  bool addedImgs = false;

  @override
  void initState() {
    super.initState();
  }


  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(0),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3),
          child: Zoom(
            colorScrollBars: Colors.transparent,
            initZoom: 0.0,
            width: 200,
            height: 200,
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
          actionBarColor: "#ffddee",
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
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.screenWidth,
                //height: SizeConfig.blockSizeVertical * 60,
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Stack(
                    children: <Widget>[


                      buildGridView(),
                      Container(
                        child: Hero(
                          tag: widget.index,
                          child: CachedNetworkImage(
                            imageUrl: widget.frameUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TemplateButton(
                        title: '1. Add Your Photos',
                        iconType: Icons.camera,
                        ontap: () {
                          loadAssets();
                        }),
                    addedImgs
                        ? TemplateButton(
                            title: '2. Finish',
                            iconType: Icons.check_circle_outline,
                            color: Colors.lightGreen,
                            ontap: () {
                              captureWidgetImage(_globalKey).then((generatedGrid) async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FinalGrid(generatedGrid)));
                              });
                            },
                          )
                        : Container(),

            ],
          ),
        ),
      ]),
    ),),);
  }
}

class TemplateButton extends StatefulWidget {
  final String title;
  final Function ontap;
  final IconData iconType;
  final Color color;

  const TemplateButton(
      {Key key, this.title, @required this.ontap, this.iconType, this.color})
      : super(key: key);

  @override
  _TemplateButtonState createState() => _TemplateButtonState();
}

class _TemplateButtonState extends State<TemplateButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: FlatButton(
        child: Column(
          children: <Widget>[
            widget.iconType == null
                ? Container()
                : Icon(
                    widget.iconType,
                    color: Colors.white,
                    size: 50,
                  ),
            widget.title == null
                ? Container()
                : Text(widget.title,
                    style: TextStyle(color: Colors.white, fontSize: 19)),
          ],
        ),
        color: widget.color == null ? Constants.paleBlue : widget.color,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18)),
        onPressed: widget.ontap,
        focusColor: Constants.brightPurple,
        hoverColor: Colors.black,
        splashColor: Colors.red,
        padding: EdgeInsets.all(10),

        //function to change selectedVar goes here
      ),
    );
  }
}
