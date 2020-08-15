// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/components/custom_dialog_widget.dart';
import 'package:instasmart/utils/size_config.dart';
import '../constants.dart';

class TipDialogWidget extends StatelessWidget {
  final Alignment alignment;
  final String tipText;

  const TipDialogWidget({Key key, this.alignment, this.tipText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: SizeConfig.blockSizeHorizontal * 300,
      margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 85),
      child: RaisedButton(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey,
          elevation: 10,
          child: Icon(
            Icons.help,
            color: Theme.of(context).accentColor,
            size: SizeConfig.blockSizeHorizontal * 8,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50)),
              side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.grey)),
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

class TipTextWidget extends StatelessWidget {
  final String tipBody;

  const TipTextWidget({Key key, @required this.tipBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
      width: SizeConfig.blockSizeHorizontal * 75,
      child: Column(
        children: <Widget>[
          Text(
            '#InstaSmartTip!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          Text(
            tipBody,
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
