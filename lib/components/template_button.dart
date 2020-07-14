// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/utils/size_config.dart';
import 'package:instasmart/constants.dart';

class TemplateButton extends StatefulWidget {
  final String title;
  final Function ontap;
  final IconData iconType;
  final Color color;

  const TemplateButton(
      {Key key, this.title, @required this.ontap, this.iconType, this.color})
      : super(key: key);

  @override
  _TemplateButtonState createState() => _TemplateButtonState();
}

class _TemplateButtonState extends State<TemplateButton> {
  @override
  Widget build(BuildContext context) {
    final Color ButtonColor = widget.color ?? Constants.paleBlue;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 0.5,
          vertical: SizeConfig.blockSizeVertical * 0.4),
      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: RaisedButton(
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.iconType == null
                ? Container(
                    width: 0,
                    height: 0,
                  )
                : Icon(
                    widget.iconType,
                    color: ButtonColor,
                    size: SizeConfig.blockSizeHorizontal * 8,
                  ),
            widget.title == null
                ? Container()
                : Text(
                    widget.title,
                    style: TextStyle(color: ButtonColor, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
        color: widget.color == null ? Colors.white : Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(12),
            side: BorderSide(color: Colors.white, width: 1)),
        onPressed: widget.ontap,
        focusColor: Constants.brightPurple,
        hoverColor: Colors.black,
        splashColor: Constants.palePink,
        padding: EdgeInsets.all(10),

        //function to change selectedVar goes here
      ),
    );
  }
}
