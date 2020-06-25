import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/frames_firebase_functions.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/screens/liked_screen.dart';
import 'package:instasmart/widgets/frame_widget.dart';
import '../categories.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instasmart/screens/create_grid_screen.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

//TODO: add 'Explore' and 'Liked' to topbar
//filter list base on that
// https://github.com/Ephenodrom/Flutter-Advanced-Examples/tree/master/lib/examples/filterList
class FramesScreen extends StatefulWidget {
  static const routeName = '/frames';
  @override
  _FramesScreenState createState() => _FramesScreenState();
}

class _FramesScreenState extends State<FramesScreen> {
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("FramesPNG");
  String _downloadurl;
  bool imagePressed = false;
  int imageNoPressed;
  final collectionRef = Firestore.instance.collection('allframespngurl');
  String selectedCat = Categories.all;

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

  List frameList = new List(); //initial list, not to be changed
  List<Frame> filteredFrameList = new List<Frame>(); //filtered list

  Future<List<Frame>> futList;

  @override
  void initState() {
    super.initState();
    //uploadImagetoFirestore();// done initially to refresh store of images.
    //TODO: automatically refresh store of images.
    futList = FramesFirebaseFunctions().GetUrlAndIdFromFirestore(selectedCat);
    FramesFirebaseFunctions()
        .GetUrlAndIdFromFirestore(selectedCat)
        .then((value) {
      setState(() {
        frameList = value;
        filteredFrameList = frameList;
      });
    });
    imagePressed = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PageTopBar(
        title: 'Frames',
        appBar: AppBar(),
        widgets: <Widget>[
          IconButton(
            //Like Button
            alignment: Alignment.centerRight,
            iconSize: 2,
            icon: Icon(Icons.favorite_border,
                size: 30, color: Constants.paleBlue),
            tooltip: 'Click to see liked frames.',
            onPressed: () {
              Navigator.pushNamed(context, LikedScreen.routeName);
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                    0,
                    3,
                    // SizeConfig.blockSizeVertical * 3,
                    0,
                    3),
                // SizeConfig.blockSizeVertical * 2),
                height: 100,
                //SizeConfig.blockSizeVertical * 20,
                child: Row(
                  children: <Widget>[
                    Container(
                      //SizeConfig.blockSizeHorizontal * 90,
                      padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                      //  SizeConfig.blockSizeHorizontal * 2, 0, 0, 0),
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.blockSizeVertical * 6,
                      child:
//                        Wrap(
//                          spacing: 2,
//                          runSpacing: 3,
//                          children: List.generate(
//                              Categories.catNamesList.length, (index) {
//                            return new CategoryButton(
//                              catName: Categories.catNamesList[index],
//                              selectedCat: selectedCat,
//                              ontap: () => setState(() {
//                                selectedCat = Categories.catNamesList[index];
//                                filteredFrameList = FramesFirebaseFunctions()
//                                    .filterFrames(selectedCat, frameList);
//                                // updateFramesList();
////                              print("selectedcat is: ${selectedCat}");
////                              print('new framelist is: ${filteredFrameList}');
//                              }),
//                            );
//                          }),
//                        )
                          //DONT DELETE
                          ListView.builder(
                        padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                        scrollDirection: Axis.horizontal,
                        itemCount: Categories.catNamesList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            new CategoryButton(
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
                  ],
                ),
              ),
              Container(
                //  padding: EdgeInsets.fromLTRB(
                //     0, SizeConfig.blockSizeVertical * 3, 0, 0),
                height: SizeConfig.blockSizeVertical * 68,
                child: FutureBuilder(
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
                      return Container(
                        height: 500,
                        child: GridView.count(
                            crossAxisCount: 3,
                            children: List.generate(
                                snapshot.data.length,
                                (index) => Container(
                                      //child: Hero(
                                      //tag: index,
                                      child: buildFrameToDisplay(index),
                                    ))
                            //), //change to document.snapshot length
                            ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          imagePressed ? buildPopUpImage(imageNoPressed) : Container(), //
        ],
      ),
    );
  }

  Widget buildFrameToDisplay(int index) {
    try {
      print("filteredframelist is");
      Frame_Widget frameWidget =
          new Frame_Widget(frame: filteredFrameList[index], isLiked: false);
      //isLiked should be true if image exists in user's likedframes collection.
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateScreen(filteredFrameList[index].imgurl, index),
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
      color: Color(0x88000000),
      child: Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
                color: Colors.white,
                child: CachedNetworkImage(
                    imageUrl: filteredFrameList[index].imgurl))),
      ),
    );
  }
}

class CategoryButton extends StatefulWidget {
  final String catName;
  final Function ontap;
  final String selectedCat;

  const CategoryButton(
      {Key key,
      @required this.catName,
      @required this.ontap,
      @required this.selectedCat})
      : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 0, 3, 5),
      child: RaisedButton(
        elevation: 1,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text("#" + widget.catName,
            style: TextStyle(color: Colors.black, fontSize: 17)),
        color: widget.selectedCat == widget.catName
            ? Constants.paleBlue
            : Colors.white,
        shape: Constants.buttonShape,
        onPressed: widget.ontap,
        focusColor: Constants.brightPurple,
        hoverColor: Colors.black,
        splashColor: Colors.red,

        //function to change selectedVar goes here
      ),
    );
  }
}

class PageTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const PageTopBar({Key key, this.title, this.appBar, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      actions: widgets,
      iconTheme:
          IconThemeData(color: Constants.paleBlue //change your color here
              ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
