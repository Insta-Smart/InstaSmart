import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/frames_firebase_functions.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/create_grid_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:instasmart/widgets/frame_widget.dart';
import '../constants.dart';
import '../main.dart';
import 'frames_screen.dart';

class LikedScreen extends StatefulWidget {
  static const routeName = '/liked';
  @override
  _LikedScreenState createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  bool imagePressed = false;
  int imageNoPressed;
  final userRef = Firestore.instance.collection('Users');
  final FirebaseFunctions firebase = FirebaseFunctions();
  User user;

  List frameList = new List();
  Future<List<Frame>> futList;

  Future<List<Frame>> getUrlAndIdFromFirestore() async {
    //updates LinkdHashMap with imageurls
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
          frameList.add(Frame(imgurl: el.data['imgurl'], imgID: el.documentID));
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
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
//                    IconButton(
//                      iconSize: 35,
//                      icon: Icon(
//                        Icons.arrow_back,
//                        color: Constants.paleBlue,
//                      ),
//                      onPressed: () {
//                        setState(() {
//                          Navigator.pop(context);
//                        });
//                      },
//                    ),
//                    Container(
//                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                      child: Text(
//                        "Liked",
//                        style: (TextStyle(fontSize: 45.0)),
//                      ),
//                    ),
                      ],
                    ),
                    FutureBuilder(
                        future: futList,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Frame>> snapshot) {
                          Widget outerChild = Center(
                            child: Text('Loading...',
                                style: TextStyle(fontSize: 50)),
                          );
                          if (snapshot.hasData) {
                            outerChild = GridView.builder(
                                itemCount: frameList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Container(
                                            child: Hero(
                                          tag: index,
                                          child: buildFrameToDisplay(index),
                                        )));
                          }
                          if (snapshot.hasError) {
                            outerChild = Center(
                              child: Text('Error. Please Refresh The Page',
                                  style: TextStyle(fontSize: 50)),
                            );
                          }
                          return Expanded(
                            child: outerChild,
                          );
                        })
                  ]),
              imagePressed ? buildPopUpImage(imageNoPressed) : Container(), //
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    try {
      print(frameList);
      Frame_Widget frameWidget = new Frame_Widget(
        frame: frameList[index],
        isLiked: true,
      );
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateScreen(frameList[index].imgurl, index),
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

  Widget buildPopUpImage(int index) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(imageUrl: frameList[index].imgurl)),
          ),
        ],
      ),
    );
  }
}
