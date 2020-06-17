import 'dart:collection';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/screens/calendar_screen.dart';
import 'package:instasmart/screens/liked_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instasmart/screens/create_grid_screen.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:instasmart/widgets/frame_widget.dart';
import '../constants.dart';
import '../main.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link
//TODO: use Snapshot to get data length

class FramesScreen extends StatefulWidget {
  static const routeName = '/frames';
  @override
  _FramesScreenState createState() => _FramesScreenState();
}

class _FramesScreenState extends State<FramesScreen> {
  // StorageReference _reference = FirebaseStorage.instance.ref("AllFrames").child("AllFrames").child("testImage.jpg");
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("FramesPNG");
  String _downloadurl;
  bool imagePressed = false;
  int imageNoPressed;
  final collectionRef = Firestore.instance.collection('allframespngurl');

  Future setDownloadUrl(int index) async {
    //downloads image from storage, based on index [files named as sample_index
    // to directly display this image, use Image.network(_downloadurl)
    try {
      String downloadAddress = await _reference
          .child("Untitled_Artwork ${index} copy.png")
          .getDownloadURL(); //image name
      //     print(downloadAddress);
      setState(() {
        _downloadurl = downloadAddress;
        print(_downloadurl);
      });
    } catch (e) {
      print(e);
    }
  }

  void uploadImagetoFirestore() {
    for (int i = 0; i < 23; i++) {
      setDownloadUrl(i).then((value) {
        collectionRef.add({'imageurl': _downloadurl, 'popularity': 0});
        print("sent");
      });
      //print("new_downloadurl is ${_downloadurl}");
    }
  }

  List frameList = new List();
  List frameUrls = new List();
  Future<List<Frame>> futList;

  Future<List<Frame>> getUrlAndIdFromFirestore() async {
    //updates LinkdHashMap with imageurls
    frameList = new List<Frame>();
    await collectionRef
        .orderBy("popularity", descending: true)
        .getDocuments()
        .then((value) {
      value.documents.forEach((el) {
        print(el.data);
        setState(() {
          if (el.data['imageurl'] == null || el.data['imageurl'] == "") {
            print("null url");
          } else {
            //    print(el.data['imageurl']);
            frameList
                .add(Frame(imgurl: el.data['imageurl'], imgID: el.documentID));
            frameUrls.add(el.data['imageurl']);
          }
          //create a map
        });
      });
    });

    print('frame data:');
    print(frameList);
    return frameList;
  }

  //RETURNS IMGID IN ALLFRAMESPNGURL BY USING IMGURL
  //CREATES A FRAME MODEL ALSO
  //TODO:DONT DELETE THIS
  Future<String> getFrameID(String imgurl) async {
    String imgID;
    var result =
        await collectionRef.where("imageurl", isEqualTo: imgurl).getDocuments();
    result.documents.forEach((res) {
      imgID = res.documentID;
    });
    print('imgID is ${imgID}');
    // frame = Frame(imgurl: widget.imgurl, imgID: imgID);
    return imgID;
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
                    "Frames",
                    style: (TextStyle(fontSize: 45.0)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      //Search Button
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Icon(Icons.search, color: Colors.white),
                          Text(
                            "Search Aesthetics",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      width: 200,
                      height: 45,
                      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Constants.buttonRadius),
                        color: Constants.paleBlue,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        //Like Button
                        alignment: Alignment.centerRight,
                        iconSize: 1,
                        icon: Icon(Icons.favorite_border,
                            size: 30, color: Constants.paleBlue),
                        tooltip: 'Click to see liked frames.',
                        onPressed: () {
                          Navigator.pushNamed(context, LikedScreen.routeName);
                        },
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: futList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.none ||
                        snapshot.hasData == null ||
                        snapshot.data == null) {
                      //print('project snapshot data is: ${projectSnap.data}');
                      return Center(
                        child:
                            Text('Loading...', style: TextStyle(fontSize: 50)),
                      );
                    } else {
                      print('building frames');
                      return Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                              snapshot.data.length,
                              (index) => Container(
                                  child: Hero(
                                    tag: index,
                                    child: buildFrameToDisplay(
                                        index),
                                  ))), //change to document.snapshot length
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            imagePressed ? buildPopUpImage(imageNoPressed) : Container(), //
          ],
        ),
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    try {
      print(frameList);
      Frame_Widget frameWidget =
          new Frame_Widget(frame: frameList[index], isLiked: false);
      //isLiked should be true if image exists in user's likedframes collection.
      return GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateScreen(frameUrls[index], index),
              )
          );
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
                child: CachedNetworkImage(imageUrl:frameList[index].imgurl)),
          ),
        ],
      ),
    );
  }
}
