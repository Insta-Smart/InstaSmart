import 'package:flutter/material.dart';
import 'package:instasmart/utils/size_config.dart';
import 'dart:io';
import 'package:social_share_plugin/social_share_plugin.dart';

import '../../../constants.dart';

class OrderElement extends StatefulWidget {
  OrderElement({
    Key key,
    @required this.filePaths,
    @required this.index,
  }) : super(key: key);

  final List<String> filePaths;
  final int index;

  @override
  _OrderElementState createState() => _OrderElementState();
}

class _OrderElementState extends State<OrderElement> {
  List<String> filePaths;
  int index;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    filePaths = widget.filePaths;
    index = widget.index;
    return GestureDetector(
      onTap: () async {
        await SocialSharePlugin.shareToFeedInstagram(
          path: filePaths[filePaths.length - index - 1],
          onSuccess: (String) {
            //print('index ${index + 1} success');
            setState(() {
              pressed = true;
            });
          },
          onCancel: () {
            print('cancel');
            setState(() {
              pressed = true;
            });
          },
        );
      },
      child: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black),
          ),
          child: Image.file(
            File(filePaths[filePaths.length - index - 1]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(45),
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 10,
            height: SizeConfig.blockSizeHorizontal * 10,
            decoration: new BoxDecoration(
              color: pressed
                  ? Colors.green.withOpacity(0.8)
                  : Constants.darkPurple.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(3, SizeConfig.blockSizeHorizontal),
                ),
              ],
            ),
            child: Center(
              child: FlatButton(
                onPressed: () async {
                  await SocialSharePlugin.shareToFeedInstagram(
                    path: filePaths[filePaths.length - index - 1],
                    onSuccess: (String) {
                      //   print('index ${index + 1} success');
                      setState(() {
                        pressed = true;
                      });
                    },
                    onCancel: () {
                      print('cancel');
                      setState(() {
                        pressed = true;
                      });
                    },
                  );
                },
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
