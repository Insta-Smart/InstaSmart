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
    return Scaffold(
        appBar: PageTopBar(
          title: 'Plan Your Feed',
          appBar: AppBar(),
          widgets: <Widget>[],
        ),
        body: Column(
          children: <Widget>[
            Row(
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
            Expanded(
              child: pickedScreen,
            )
          ],
        ));
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
    return Container(
      child: FlatButton(
        child: Text(widget.title),
        onPressed: widget.ontap,
        color: widget.origPressed == widget.index ? Colors.grey : Colors.white,
      ),
      //function to change selectedVar goes here
    );
  }
}
