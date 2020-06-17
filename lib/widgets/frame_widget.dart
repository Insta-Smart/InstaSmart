import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/models/frame.dart';
import 'package:instasmart/models/liking_functions.dart';
import '../constants.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  bool
      liked; //TODO: change to checking whether imgurl exists in user's collection
  final collectionRef = Firestore.instance.collection('allframespngurl');
  final userRef = Firestore.instance.collection('Users');
  final db = Firestore.instance;
  final FirebaseFunctions firebase = FirebaseFunctions();
  User user;

  //RETURNS NUMBER OF LIKES THE IMAGE HAS AS A DOUBLE
  Future<double> getNumLikes() async {
    var num; //int if 0, double otherwise
    //getDocuments.then(value ....) {el.data.field or smth --> need to do this everytime its clickec --> change state of numLikes}
    try {
      await collectionRef
          .document(widget.frame.imgID)
          .get()
          .then((DocumentSnapshot document) {
        num = document.data['popularity'];
        print(widget.frame.imgID);
        print(widget.frame.imgurl);
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

//  bool setInitLikedStat() {
//    bool liked;
//    if (widget.isLiked == null) {
//      LikingFunctions().getInitLikedStat(widget.frame.imgID).then((value) {
//        print('value is ');
//        print(value);
//        liked = value;
//      });
//    } else {
//      liked = widget.isLiked;
//    }
//    return liked;
//  }

  @override
  void initState() {
    //TODO: put future here
    liked = false;

    super.initState();
    if (!widget.isLiked) {
      //TODO: this is returning null???
      // liked = LikingFunctions().getInitLikedStat(widget.frame.imgID);
      LikingFunctions().futInitLikedStat(widget.frame.imgID).then((value) {
        print('value of initlikedstate is: ${value}');
        setState(() {
          liked = value;
        });
      });
      print('final liked is ${liked}');
    } else {
      setState(() {
        liked = true;
      });
    }
    setNumLikes();
    print('outcome of setinitlikedstate:');

//    print('outcome of setinitlikedstate:');
//    print(LikingFunctions().getInitLikedStat(widget.frame.imgID));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: CachedNetworkImage(
              imageUrl: widget.frame.imgurl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
//          ClipRRect(
//              borderRadius: BorderRadius.circular(25),
//              child: Image.network(widget.frame.imgurl)),
        ),
        IconButton(
          //Like Button
          alignment: Alignment(-9, -13),
          icon: Icon(
            Icons.favorite,
            size: 30,
            color: liked ? Constants.palePink : Colors.grey,
          ),
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
                ? LikingFunctions()
                    .addImgToLiked(widget.frame.imgID, widget.frame.imgurl)
                : LikingFunctions().delImgFromLiked(widget.frame.imgID);
          },
        ),
        Container(
          child: Container(
            color: Colors.white60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Constants.palePink,
                  size: 15,
                ),
                Text('${_numLikes}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
          ),
          alignment: Alignment(0, 0.8),
        ),
      ],
    );
  }
}
