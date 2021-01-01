// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/services/liking_functions.dart';
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
    try {
      // print('frame widget info:' + widget.frame.imgID);
      await collectionRef
          .document(widget.frame.imgID)
          .get()
          .then((DocumentSnapshot document) {
        num = document.data['popularity'];
        // // print('in getNumLIkes function: ' +
        //      widget.frame.imgID +
        //      ' and ' +
        //      num.toString());
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
    if (!widget.isLiked) {
      LikingFunctions().futInitLikedStat(widget.frame.imgID).then((value) {
        //print('value of initlikedstate is: ${value}');
        if (mounted) {
          setState(() {
            liked = value;
          });
        }
      });
    } else {
      setState(() {
        liked = true;
      });
    }
    setNumLikes();
    //print('outcome of setinitlikedstate:');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('frame_widget being built');
    LikingFunctions().futInitLikedStat(widget.frame.imgID).then((value) {
      if (liked != value) {
        setState(() {
          liked = value;
        });
      }
    });
    getNumLikes().then((value) {
      if (_numLikes != value.round()) {
        setState(() {
          _numLikes = value.round();
        });
      }
    });
    //  updateLikes();
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: SizeConfig.blockSizeVertical * 18,
            width: SizeConfig.blockSizeVertical * 19,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
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
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
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
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    key: Key('increment ${widget.frame.lowResUrl}'),
                    focusColor: Constants.palePink,
                    padding: EdgeInsets.zero,
                    icon: liked
                        ? Icon(
                            Icons.favorite,
                            size: 25,
                            color: Constants.palePink,
                            key: Key('iconWidget ' + widget.frame.lowResUrl),
                          )
                        : Icon(
                            Icons.favorite_border,
                            size: 25,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                        //print("liked status is: $liked");
                        //increment popularity of this image, identified by imgurl
                        liked ? _numLikes++ : _numLikes--; //update _numLikes
                      });

                      LikingFunctions().updateLikes(widget.frame.imgID, liked);

                      //if liked is true --> add image to user collection.
                      // if liked is false --> REMOVE image from collection
                      liked
                          ? LikingFunctions().addImgToLiked(widget.frame.imgID,
                              widget.frame.lowResUrl, widget.frame.highResUrl)
                          : LikingFunctions()
                              .delImgFromLiked(widget.frame.imgID);
                    },
                  ),
                  _numLikes == null
                      ? Container()
                      : Text('$_numLikes',
                          key: Key('counter ${widget.frame.lowResUrl}'),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
