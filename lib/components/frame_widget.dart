// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import '../constants.dart';
import 'package:instasmart/utils/liking_functions.dart';
import 'package:instasmart/models/frame.dart';

class Frame_Widget extends StatefulWidget {
  final Frame frame;
  final bool isLiked;

  Frame_Widget({Key key, @required this.frame, @required this.isLiked})
      : super(key: key);

  @override
  _Frame_WidgetState createState() => _Frame_WidgetState();
}

class _Frame_WidgetState extends State<Frame_Widget> {
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
      print('frame widget info:' + widget.frame.imgID);
      await collectionRef
          .document(widget.frame.imgID)
          .get()
          .then((DocumentSnapshot document) {
        num = document.data['popularity'];
        print(widget.frame.imgID);
        print(widget.frame.lowResUrl);
      });
      print(num);
      return num is int ? num.toDouble() : num;
    } catch (e) {
      print('error in get num likes is');
      print(e);
    }
  }

  //DOES getNumLikes() --> SETS VAR NUM TO RESULT AS INTEGER, TAKES IN IMGID
  void setNumLikes() {
    getNumLikes().then((double num) {
      setState(() {
        _numLikes = num.round();
        print('${widget.frame.imgID} has ${num} likes');
      });
    });
  }

  @override
  void initState() {
    liked = false;
    super.initState();
    if (!widget.isLiked) {
      LikingFunctions().futInitLikedStat(widget.frame.imgID).then((value) {
        print('value of initlikedstate is: ${value}');
        if (mounted) {
          setState(() {
            liked = value;
          });
        }
      });
      print('final liked is ${liked}');
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
// L-R margin should be same as GridView container margin in frames_screen.dart
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: CachedNetworkImage(
                  imageUrl: widget.frame.lowResUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Expanded(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )),
        ),

//          ClipRRect(
//              borderRadius: BorderRadius.circular(25),
//              child: Image.network(widget.frame.imgurl)),

        Material(
          type: MaterialType.transparency,
          color: Colors.white,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              //Like Button
              alignment: Alignment(-6, -13),
              icon: Icon(Icons.favorite,
                  size: 30,
                  color: liked ? Constants.palePink : Color(0xffdde0dd)),
              tooltip: 'Like frame to save it.',
              onPressed: () {
                setState(() {
                  liked = !liked;
                  print("liked status is: ${liked}");
                  //increment popularity of this image, identified by imgurl
                  liked ? _numLikes++ : _numLikes--; //update _numLikes
                });

                LikingFunctions().updateLikes(widget.frame.imgID, liked);

                //if liked is true --> add image to user collection.
                // if liked is false --> REMOVE image from collection
                liked
                    ? LikingFunctions().addImgToLiked(widget.frame.imgID,
                        widget.frame.lowResUrl, widget.frame.highResUrl)
                    : LikingFunctions().delImgFromLiked(widget.frame.imgID);
              },
            ),
          ),
        ),
        Container(
          child: Container(
            color: Colors.white.withOpacity(0.8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Constants.palePink,
                  size: 15,
                ),
                _numLikes == null
                    ? Container()
                    : Text('${_numLikes}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
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
