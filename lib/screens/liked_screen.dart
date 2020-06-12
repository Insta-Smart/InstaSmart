import 'dart:collection';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/preview_screen.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:instasmart/widgets/frame_widget.dart';
import '../constants.dart';
import '../main.dart';

class LikedScreen extends StatefulWidget {
  static const routeName = '/liked';
  @override
  _LikedScreenState createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  // StorageReference _reference = FirebaseStorage.instance.ref("AllFrames").child("AllFrames").child("testImage.jpg");
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("FramesPNG");

  bool imagePressed = false;
  int imageNoPressed;
  final userRef = Firestore.instance.collection('Users');
  final FirebaseFunctions firebase = FirebaseFunctions();
  User user;

  Map ImgsMap = LinkedHashMap<String, String>();

  void getUrlAndIdFromFirestore() async {
    //updates LinkdHashMap with imageurls
    try {
      user = await firebase.currentUser();
      print('user id is');
      print(user.uid);
      ImgsMap = LinkedHashMap<String, String>();
      await userRef
          .document(user.uid)
          .collection('LikedFrames')
          .getDocuments()
          .then((value) {
        value.documents.forEach((el) {
          print(el.documentID);
          ImgsMap.putIfAbsent(el.data['imgurl'], () => el.documentID);
        });
      });

      ImgsMap.removeWhere((key, value) => key == null);
      print('hashmap is');
      print(ImgsMap.keys.toList());
    } catch (e) {
      print('error in likedscreen is ${e}');
    }
  }

  @override
  void initState() {
    super.initState();
    //uploadImagetoFirestore();// done initially to refresh store of images.
    //TODO: automatically refresh store of images.
    getUrlAndIdFromFirestore();
    imagePressed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Liked Frames",
                    style: (TextStyle(fontSize: 45.0)),
                  ),
                ),
                Row(
                  children: <Widget>[],
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                        1,
                        (index) => Container(
                            child: buildFrameToDisplay(
                                0))), //change to document.snapshot length
                  ),
                ),
              ],
            ),
            imagePressed ? Container() : Container(), //
          ],
        ),
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    String Imgurl = ImgsMap.keys.toList()[index];
    String ImgId = ImgsMap.values.toList()[index];
    Frame_Widget frameWidget =
        new Frame_Widget(frame: Frame(imgurl: Imgurl, imgID: ImgId));
    return GestureDetector(
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
  }

//  Widget buildPopUpImage(int index) {
//    return Container(
//      alignment: Alignment.center,
//      child: Stack(
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//              color: Colors.white,
//            ),
//            child: ClipRRect(
//                borderRadius: BorderRadius.circular(25),
//                child: Image.network(ImgsMap.keys.toList()[index])),
//          ),
//        ],
//      ),
//    );
//  }
}
