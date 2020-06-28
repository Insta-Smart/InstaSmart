import 'package:flutter/material.dart';
import 'package:instasmart/models/size_config.dart';
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
    return Container(
      padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: FlatButton(
        child: Column(
          children: <Widget>[
            widget.iconType == null
                ? Container()
                : Icon(
              widget.iconType,
              color: Colors.white,
              size: SizeConfig.blockSizeHorizontal*10,
            ),
            widget.title == null
                ? Container()
                : Text(widget.title,
                style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeHorizontal*4)),
          ],
        ),
        color: widget.color == null ? Constants.paleBlue : widget.color,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18)),
        onPressed: widget.ontap,
        focusColor: Constants.brightPurple,
        hoverColor: Colors.black,
        splashColor: Colors.red,
        padding: EdgeInsets.all(10),

        //function to change selectedVar goes here
      ),
    );
  }
}
