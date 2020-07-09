//import 'package:flutter/cupertino.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:instasmart/models/frame.dart';
//import 'package:instasmart/models/frames_firebase_functions.dart';
//import 'package:instasmart/models/size_config.dart';
//import 'package:instasmart/screens/liked_screen.dart';
//import 'package:instasmart/widgets/frame_widget.dart';
//import '../categories.dart';
//import '../constants.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:instasmart/screens/create_grid_screen.dart';
//
////https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link
//
////TODO: add 'Explore' and 'Liked' to topbar
////filter list base on that
//// https://github.com/Ephenodrom/Flutter-Advanced-Examples/tree/master/lib/examples/filterList
//class FrameTest extends StatefulWidget {
//  static const routeName = '/frames';
//  @override
//  _FrameTestState createState() => _FrameTestState();
//}
//
//class _FrameTestState extends State<FrameTest> {
//
//  Future setDownloadUrl(int index) async {
//    //downloads image from storage, based on index [files named as sample_index
//    // to directly display this image, use Image.network(_downloadurl)
//    try {
//      String downloadAddress = await _reference
//          .child("Untitled_Artwork ${index} copy.jpg")
//          .getDownloadURL(); //image name
//      //     print(downloadAddress);
//      setState(() {
//        _downloadurl = downloadAddress;
//        print(_downloadurl);
//      });
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  void uploadImagetoFirestore() {
//    for (int i = 0; i < 23; i++) {
//      setDownloadUrl(i).then((value) {
//        collectionRef.add({'imageurl': _downloadurl, 'popularity': i});
//        print("sent");
//      });
//      //print("new_downloadurl is ${_downloadurl}");
//    }
//  }
//
//  bool imagePressed = false;
//  int imageNoPressed;
//  String _downloadurl;
//  StorageReference _reference =
//  FirebaseStorage.instance.ref().child("Frames (<100kb)");
////  final collectionRef = Firestore.instance.collection('allframessmall');
//  final collectionRef = Firestore.instance.collection('Resized_Frames');
//  String selectedCat = Categories.all;
//
//  List <Frame>frameList = new List<Frame>(); //initial list, not to be changed
//  List<Frame> filteredFrameList = new List<Frame>(); //filtered list
//
//  Future<List<Frame>> futList;
//
//  @override
//  void setState(fn) {
//    if(mounted){
//      super.setState(fn);
//    }
//  }
//  void initState() {
//    uploadImagetoFirestore();
//    super.initState();
//    futList =
//        FramesFirebaseFunctions().GetUrlAndIdFromFirestore(Categories.all);
//    futList.then((value) {
//      frameList = value;
//      filteredFrameList = frameList;
//    });
//    imagePressed = false;
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    SizeConfig().init(context);
//    return SafeArea(
//      child: Scaffold(
////      appBar: PageTopBar(
////        title: 'Frames',
////        appBar: AppBar(),
////        widgets: <Widget>[
//////          IconButton(s
//////            //Like Button
//////            alignment: Alignment.centerRight,
//////            iconSize: 2,
//////            icon: Icon(Icons.favorite_border,
//////                size: 30, color: Constants.paleBlue),
//////            tooltip: 'Click to see liked frames.',
//////            onPressed: () {
//////              Navigator.pushNamed(context, LikedScreen.routeName);
//////            },
//////          ),
////        ],
//        //),
//        body: Expanded(
//          child: FutureBuilder(
//            future: futList,
//            builder: (BuildContext context,
//                AsyncSnapshot<List<Frame>> snapshot) {
//              Widget outerChild = Center(
//                child:
//                Text('Loading...', style: TextStyle(fontSize: 50)),
//              );
//              if (snapshot.hasData &&
//                  snapshot.connectionState == ConnectionState.done) {
//                outerChild = GridView.builder(
//                    itemCount: filteredFrameList.length,
//                    gridDelegate:
//                    SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 3),
//                    itemBuilder: (BuildContext context, int index) =>
//                        Container(
//                            child: Hero(
//                              tag: index,
//                              child: CachedNetworkImage(imageUrl: snapshot.data[index].imgurl,)
//                            )));
//
//              }
//              if (snapshot.hasError) {
//                outerChild = Center(
//                  child: Text('Error. Please Refresh The Page',
//                      style: TextStyle(fontSize: 50)),
//                );
//              }
//              if (snapshot.connectionState == ConnectionState.none) {}
//              return Container(
//                child: outerChild,
//              );
//            },
//          ),
//        )
//    ),
//    );}}