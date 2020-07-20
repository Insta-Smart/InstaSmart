// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:showcaseview/showcaseview.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/components/tip_widgets.dart';

// Project imports:
import '../../constants.dart';
import './components/category_button.dart';
import 'package:instasmart/categories.dart';
import 'package:instasmart/components/frame_widget.dart';
import 'package:instasmart/components/popup_widget.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/services/frames_firebase_functions.dart';
import 'package:instasmart/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

// https://github.com/Ephenodrom/Flutter-Advanced-Examples/tree/master/lib/examples/filterList
class FramesScreen extends StatefulWidget {
  static const routeName = '/frames';
  final User user;

  FramesScreen({Key key, @required this.user}) : super(key: key);
  @override
  _FramesScreenState createState() => _FramesScreenState();
}

class _FramesScreenState extends State<FramesScreen> {
  bool imagePressed = false;
  int imageNoPressed;
  final collectionRef =
      Firestore.instance.collection(Constants.ALL_FRAMES_COLLECTION);
  String selectedCat = Categories.all;

  List<Frame> frameList = new List<Frame>(); //initial list, not to be changed
  List<Frame> filteredFrameList = new List<Frame>(); //filtered list

  Future<List<Frame>> futList;

  @override
  void initState() {
    super.initState();
    // FramesFirebaseFunctions().uploadImagetoFirestore();
    futList =
        FramesFirebaseFunctions().GetUrlAndIdFromFirestore(Categories.all);
    futList.then((value) {
      frameList = value;
      filteredFrameList = frameList;
    });
    imagePressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //SizeConfig.blockSizeHorizontal * 90,
                    color: Colors.transparent,
                    margin: EdgeInsets.fromLTRB(
                        0, SizeConfig.blockSizeVertical * 2, 0, 5),
                    //  SizeConfig.blockSizeHorizontal * 2, 0, 0, 0),
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.blockSizeVertical * 6,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: Categories.catNamesList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          CategoryButton(
                        catName: Categories.catNamesList[index],
                        selectedCat: selectedCat,
                        ontap: () => setState(() {
                          selectedCat = Categories.catNamesList[index];
                          filteredFrameList = FramesFirebaseFunctions()
                              .filterFrames(selectedCat, frameList);
                          // updateFramesList();
//                              print("selectedcat is: ${selectedCat}");
//                              print('new framelist is: ${filteredFrameList}');
                        }),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: futList,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Frame>> snapshot) {
                        if (!snapshot.hasData) {
                          return Expanded(
                            child: GridView.builder(
                              itemCount: 15,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) =>
                                  Container(
                                child: Hero(
                                  tag: index,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Container(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: GridView.builder(
                              itemCount: filteredFrameList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) =>
                                  Container(
                                child: Hero(
                                  tag: index,
                                  child: buildFrameToDisplay(index),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ]),
            TipDialogWidget(
              tipText: 'Tap the ♥ to save your favourite frames!',
              alignment: Alignment.bottomRight,
            ),
            imagePressed
                ? PopupWidget(
                    imgUrl: filteredFrameList[imageNoPressed].lowResUrl)
                : Container(), //
          ],
        ),
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    try {
      FrameWidget frameWidget =
          new FrameWidget(frame: filteredFrameList[index], isLiked: false);
      //isLiked should be true if image exists in user's likedframes collection.
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateScreen(
                    filteredFrameList[index].highResUrl, index, widget.user),
              ));
        },
        onLongPress: () {
          print("longpress");
          //show pop up image
          setState(() {
            imagePressed = true;
            imageNoPressed = index;
          });
          // print(index);
        },
        onLongPressUp: () {
          //set state of longPressed to false
          setState(() {
            imagePressed = false;
          });
        },
        child: frameWidget,
      );
    } catch (e) {
      print('error in building screen is');
      //  tryFrame();
      print(e);
    }
  }
}
