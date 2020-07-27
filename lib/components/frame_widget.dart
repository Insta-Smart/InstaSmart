// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/services/liking_functions.dart';
import 'package:instasmart/test_driver/Keys.dart';
import 'package:instasmart/utils/size_config.dart';
import '../constants.dart';

class FrameWidget extends StatefulWidget {
  final Frame frame;
  final bool isLiked;

  FrameWidget({Key key, @required this.frame, @required this.isLiked})
      : super(key: key);

  @override
  _FrameWidgetState createState() => _FrameWidgetState();
}

class _FrameWidgetState extends State<FrameWidget> {
  int _numLikes;
  bool liked =
      true; //TODO: change to checking whether imgurl exists in user's collection
  final userRef = Firestore.instance.collection(Constants.USERS);
  final db = Firestore.instance;
  final collectionRef =
      Firestore.instance.collection(Constants.ALL_FRAMES_COLLECTION);

  //RETURNS NUMBER OF LIKES THE IMAGE HAS AS A DOUBLE
  Future<double> getNumLikes() async {
    var num; //int if 0, double otherwise
    //getDocuments.then(value ....) {el.data.field or smth --> need to do this everytime its clickec --> change state of numLikes}
    try {
      // print('frame widget info:' + widget.frame.imgID);
      await collectionRef
          .document(widget.frame.imgID)
          .get()
          .then((DocumentSnapshot document) {
        num = document.data['popularity'];
        // print(widget.frame.imgID);
        //print(widget.frame.lowResUrl);
      });
      //  print(num);

    } catch (e) {
      print('error in get num likes is');
      print(e);
    }
    return num is int ? num.toDouble() : num;
  }

  //DOES getNumLikes() --> SETS VAR NUM TO RESULT AS INTEGER, TAKES IN IMGID
  int setNumLikes() {
    getNumLikes().then((double num) {
      setState(() {
        _numLikes = num.round();
        //print('${widget.frame.imgID} has ${num} likes');
      });
    });
    return _numLikes;
  }

  @override
  void initState() {
    liked = false;
    super.initState();
    if (!widget.isLiked) {
      LikingFunctions().futInitLikedStat(widget.frame.imgID).then((value) {
        //print('value of initlikedstate is: ${value}');
        if (mounted) {
          setState(() {
            liked = value;
          });
        }
      });
      // print('final liked is ${liked}');
    } else {
      setState(() {
        liked = true;
      });
    }
    setNumLikes();
    print('outcome of setinitlikedstate:');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: SizeConfig.screenWidth * 0.5,
// L-R margin should be same as GridView container margin in frames_screen.dart
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: SizeConfig.screenWidth * 0.5,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: CachedNetworkImage(
                    imageUrl: widget.frame.lowResUrl,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: SizeConfig.screenWidth / 2,
                        width: SizeConfig.screenWidth / 2,
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              )),
        ),

//          ClipRRect(
//              borderRadius: BorderRadius.circular(25),
//              child: Image.network(widget.frame.imgurl)),
//
//        Material(
//          type: MaterialType.transparency,
//          color: Colors.white,
//          child: Material(
//            color: Colors.transparent,
//            child: IconButton(
//              //Like Button
//              alignment: Alignment(-6, -13),
//              focusColor: Constants.palePink,
//              icon: liked
//                  ? Icon(Icons.favorite,
//                      size: 30,
//                      color: liked ? Constants.palePink : Color(0xffdde0dd))
//                  : Icon(
//                      Icons.favorite,
//                      size: 30,
//                      color: Colors.grey.withOpacity(0.8),
//                    ),
//              tooltip: 'Like frame to save it.',
//              onPressed: () {
//                setState(() {
//                  liked = !liked;
//                  print("liked status is: $liked");
//                  //increment popularity of this image, identified by imgurl
//                  liked ? _numLikes++ : _numLikes--; //update _numLikes
//                });
//
//                LikingFunctions().updateLikes(widget.frame.imgID, liked);
//
//                //if liked is true --> add image to user collection.
//                // if liked is false --> REMOVE image from collection
//                liked
//                    ? LikingFunctions().addImgToLiked(widget.frame.imgID,
//                        widget.frame.lowResUrl, widget.frame.highResUrl)
//                    : LikingFunctions().delImgFromLiked(widget.frame.imgID);
//              },
//            ),
//          ),
//        ),
        Container(
          child: Container(
            color: Colors.white.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Constants.palePink,
                      size: 15,
                    ),
                    _numLikes == null
                        ? Container()
                        : Text('$_numLikes',
                            key: Key('counter ${widget.frame.lowResUrl}'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                Material(
                  type: MaterialType.transparency,
                  color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      key: Key('increment ${widget.frame.lowResUrl}'),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 5),
                      //Like Button
                      // alignment: Alignment(-6, -13),
                      focusColor: Constants.palePink,
                      icon: liked
                          ? Icon(
                              Icons.favorite,
                              size: 30,
                              color: Constants.palePink,
                              key: Key('iconWidget ' + widget.frame.lowResUrl),
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 30,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                      onPressed: () {
                        setState(() {
                          liked = !liked;
                          //print("liked status is: $liked");
                          //increment popularity of this image, identified by imgurl
                          liked ? _numLikes++ : _numLikes--; //update _numLikes
                        });

                        LikingFunctions()
                            .updateLikes(widget.frame.imgID, liked);

                        //if liked is true --> add image to user collection.
                        // if liked is false --> REMOVE image from collection
                        liked
                            ? LikingFunctions().addImgToLiked(
                                widget.frame.imgID,
                                widget.frame.lowResUrl,
                                widget.frame.highResUrl)
                            : LikingFunctions()
                                .delImgFromLiked(widget.frame.imgID);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          alignment: Alignment(0, 0.8),
        ),
      ],
    );
  }
}

//TODO: add categories - minimalist, floral, food, landscape, youthful
