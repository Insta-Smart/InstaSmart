import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

class FramesScreen extends StatefulWidget {
  static const routeName = '/frames';
  @override
  _FramesScreenState createState() => _FramesScreenState();
}

class _FramesScreenState extends State<FramesScreen> {
  File _imageFile; //image state variable

  // StorageReference _reference = FirebaseStorage.instance.ref("AllFrames").child("AllFrames").child("testImage.jpg");
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("AllFrames");
  final _firestore = Firestore.instance;
  String _downloadurl;
  List listofurls =
      new List(); //will contain list of imageurls once getUrlFromFirestore is called
  bool imagePressed = false;
  int imageNoPressed;



  void getUrlFromFirestore() async {
    //updates listofurls with imageurls
    listofurls = [];
    final allframesurl =
        await _firestore.collection('allframesurl').getDocuments();
    // allframesurl.documents --> returns a list of all items in firestore
    for (var el in allframesurl.documents) {
      setState(() {
        el.data['imageurl'] == null
            ? print('null')
            : listofurls.add(el.data['imageurl']);
      });
    }
    print(listofurls);
  }

  @override
  void initState() {
    super.initState();
    getUrlFromFirestore();
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
                Container(
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
                    borderRadius: BorderRadius.circular(Constants.buttonRadius),
                    color: Constants.paleBlue,
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children:
                        List.generate(8, (index) => buildFrameToDisplay(index)),
                  ),
                ),
              ],
            ),
            imagePressed ? buildPopUpImage(imageNoPressed) : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    return GestureDetector(
      onLongPress: () {
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
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CachedNetworkImage(
            imageUrl: listofurls[index],
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget buildPopUpImage(int index) {
    return Container(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          listofurls[index],
        ),
      ),
    );
  }
}
