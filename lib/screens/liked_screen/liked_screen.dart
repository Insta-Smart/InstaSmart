// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instasmart/utils/size_config.dart';
// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:instasmart/components/frame_widget.dart';
import 'package:instasmart/components/popup_widget.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/services/login_functions.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

class LikedScreen extends StatefulWidget {
  static const routeName = '/liked';
  @override
  _LikedScreenState createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  bool imagePressed = false;
  int imageNoPressed;
  final userRef = Firestore.instance.collection('Users');
  final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();
  User user;

  List frameList = new List<Frame>();
  Future<List<Frame>> futList;

  Future<List<Frame>> getUrlAndIdFromFirestore() async {
    frameList = new List<Frame>();
    try {
      user = await firebase.currentUser();
      print('user id is');
      print(user.uid);
      await userRef
          .document(user.uid)
          .collection('LikedFrames')
          .getDocuments()
          .then((value) {
        value.documents.forEach((el) {
          print(el.documentID);
          frameList.add(Frame(
              lowResUrl: el.data['lowResUrl'],
              imgID: el.documentID,
              highResUrl: el.data['highResUrl']));
          //frameUrls.add(el.data['imgurl']);
        });
      });
    } catch (e) {
      print('error in likedscreen is ${e}');
    }
    return frameList;
  }

  @override
  void initState() {
    super.initState();
    //uploadImagetoFirestore();// done initially to refresh store of images.
    //TODO: automatically refresh store of images.
    futList = getUrlAndIdFromFirestore();
    imagePressed = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
//      appBar: PageTopBar(
//        title: 'Liked',
//        appBar: AppBar(),
//      ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Stack(
            children: <Widget>[
              FutureBuilder(
                  future: futList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Frame>> snapshot) {
                    if (!snapshot.hasData) {
                      return Expanded(
                        child: GridView.builder(
                          itemCount: 9,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                child: Hero(
                                  tag: index,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    child: Container(
                                      height: SizeConfig.screenWidth / 3,
                                      width: SizeConfig.screenWidth / 3,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      );
                    } else {
                      return Container(
                        child: GridView.builder(
                            itemCount: frameList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                    child: Hero(
                                  tag: index,
                                  child: buildFrameToDisplay(index),
                                ))),
                      );
                    }
                    //TODO: I need to do this
                  }),
              imagePressed
                  ? PopupWidget(imgUrl: frameList[imageNoPressed].imgurl)
                  : Container(), //
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    try {
      print(frameList);
      FrameWidget frameWidget = new FrameWidget(
        frame: frameList[index],
        isLiked: true,
      );
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateScreen(frameList[index].highResUrl, index, user),
              ));
        },
        onLongPress: () {
          print("longpress");
          //show pop up image
          setState(() {
            imagePressed = true;
            imageNoPressed = index;
          });
          print(index);
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
