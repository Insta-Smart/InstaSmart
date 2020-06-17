import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'final_grid_screen.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:instasmart/models/widget_to_image.dart';
import 'package:instasmart/models/splitImage.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            width: 300,
            height: 300,
            child: AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalKey _globalKey = new GlobalKey();
    return new Scaffold(
      appBar: AppBar(
        title: Text('Create Grid'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: SizeConfig.blockSizeVertical * 60,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Create Grid'),
                    color: Colors.teal,
                    onPressed: () {
                      captureWidgetImage(_globalKey).then((value) async {
                        imageBytes = splitImage(
                            imgBytes: value,
                            horizontalPieceCount: 3,
                            verticalPieceCount: 3);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ImageDisplay(imageBytes)));
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text('Select Images'),
                    color: Colors.deepPurple,
                    onPressed: () => loadAssets(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
