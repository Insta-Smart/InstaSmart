import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Frame_Widget extends StatefulWidget {
  final String imgurl;
  bool liked; //no need

  Frame_Widget({Key key, @required this.imgurl, @required this.liked})
      : super(key: key);

  @override
  _Frame_WidgetState createState() => _Frame_WidgetState();

  bool getLiked() {
    return liked;
  }
}

class _Frame_WidgetState extends State<Frame_Widget> {
  int _numLikes = 0;
  final _firestore = Firestore.instance.collection("allframesurl");
  //Query query = _firestore.whereEqualTo("imageurl", "widget.imgurl");

  void addLike() {
    _numLikes++;
  }

  void removeLike() {
    _numLikes = _numLikes - 1;
  }

  int getLikes() {
    return _numLikes;
  }

  Image getImage() {
    return Image.network(widget.imgurl);
  }

  bool liked = false;

  bool getLiked() {
    return liked;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(widget.imgurl)),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              liked = !liked;
              print("liked status is: ${liked}");
              //increment popularity of this image, identified by imgurl
              // .where(imageurl","=="
            });
          },
          child: Icon(Icons.favorite,
              color: liked ? Constants.palePink : Colors.white),
        ),
      ],
    );
  }
}
