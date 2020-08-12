// Dart imports:
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/utils/size_config.dart';

import '../../../constants.dart';

class OrderElement extends StatefulWidget {
  OrderElement({
    Key key,
    @required this.imgBytes,
    @required this.index,
  }) : super(key: key);

  final List<Uint8List> imgBytes;
  final int index;

  @override
  _OrderElementState createState() => _OrderElementState();
}

class _OrderElementState extends State<OrderElement> {
  List<Uint8List> imgBytes;
  int index;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    imgBytes = widget.imgBytes;
    index = widget.index;
    return GestureDetector(
      onTap: () async {
        await Share.file(
          'instasmart image',
          'instasmart-image.png',
          imgBytes[imgBytes.length - index - 1],
          'image/png',
        );
        setState(() {
          pressed = true;
        }); //
//        await SocialSharePlugin.shareToFeedInstagram(
//          path: filePaths[filePaths.length - index - 1],
//          onSuccess: (string) {
//            //print('index ${index + 1} success');
//            setState(() {
//              pressed = true;
//            });
//          },
//          onCancel: () {
//            print('cancel');
//            setState(() {
//              pressed = true;
//            });
//          },
//        );
      },
      child: Stack(children: <Widget>[
        Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
            ),
            child: Image.memory(imgBytes[imgBytes.length - index - 1])),
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
                  await Share.file(
                    'instasmart image',
                    'instasmart-image.png',
                    imgBytes[imgBytes.length - index - 1],
                    'image/png',
                  );
                  setState(() {
                    pressed = true;
                  });
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
