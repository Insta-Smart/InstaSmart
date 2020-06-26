import 'package:flutter/material.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/screens/collection_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';

import '../constants.dart';
import 'frames_screen.dart';
import 'liked_screen.dart';

class PreviewCollectionScreen extends StatefulWidget {
  static const routeName = '/previewcollection';
  @override
  _PreviewCollectionScreenState createState() =>
      _PreviewCollectionScreenState();
}

class _PreviewCollectionScreenState extends State<PreviewCollectionScreen> {
  Widget pickedScreen = PreviewScreen();
  String picked;
  int origPressed = 1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
//        appBar: PageTopBar(
//          title: 'Plan Your Feed',
//          appBar: AppBar(),
//          widgets: <Widget>[],
//        ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ChoosePageButton(
                      title: "Feed Preview",
                      ontap: () => setState(() {
                        pickedScreen = PreviewScreen();
                        origPressed = 1;
                        print('preview pressed');
                      }),
                      origPressed: origPressed,
                      index: 1,
                    ),
                    new ChoosePageButton(
                      title: "Collection",
                      ontap: () {
                        setState(() {
                          pickedScreen = CollectionScreen();
                          origPressed = 2;
                        });
                        print('collection pressed');
                      },
                      origPressed: origPressed,
                      index: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Expanded(
                child: pickedScreen,
              )
            ],
          )),
    );
  }
}

class ChoosePageButton extends StatefulWidget {
  final String title;
  final Function ontap;
  final int origPressed;
  final int index;

  const ChoosePageButton({
    Key key,
    @required this.title,
    this.ontap,
    this.origPressed,
    this.index,
  }) : super(key: key);

  @override
  _ChoosePageButtonState createState() => _ChoosePageButtonState();
}

class _ChoosePageButtonState extends State<ChoosePageButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            FlatButton(
              splashColor: Colors.white,
              child: Text(
                widget.title,
                style: widget.origPressed == widget.index
                    ? TextStyle(color: Constants.paleBlue, fontSize: 17)
                    : TextStyle(color: Colors.black, fontSize: 17),
              ),
              onPressed: widget.ontap,
              color: widget.origPressed == widget.index
                  ? Colors.white
                  : Colors.white,
            ),
            widget.origPressed != widget.index
                ? Container()
                : Container(
                    color: Constants.paleBlue,
                    height: 3,
                  )
          ],
        ),
      ),
      //function to change selectedVar goes here
    );
  }
}
