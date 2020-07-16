import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/utils/size_config.dart';

import '../constants.dart';

class TipWidget extends StatelessWidget {
  final Alignment alignment;
  final String tipText;

  const TipWidget({Key key, this.alignment, this.tipText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: SizeConfig.blockSizeHorizontal * 300,
      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 85),
      child: RaisedButton(
          elevation: 10,
          child: Icon(
            Icons.help,
            color: Constants.paleBlue,
            size: SizeConfig.blockSizeHorizontal * 8,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50)),
              side: BorderSide(color: Colors.white)),
          color: Colors.white,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialogWidget(
                      title: '#InstaSmartTip!',
                      body: tipText,
                    ));
          }),
    );
  }
}
