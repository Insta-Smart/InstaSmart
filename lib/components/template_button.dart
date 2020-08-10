// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/utils/size_config.dart';

class TemplateButton extends StatefulWidget {
  final String title;
  final Function ontap;
  final IconData iconType;
  final Color color;
  final String spinkitMes1;
  final String spinkitMes2;
  final CustomDialogWidget finishDialog;

  const TemplateButton(
      {Key key,
      this.title,
      @required this.ontap,
      this.iconType,
      this.color,
      this.spinkitMes1,
      this.spinkitMes2,
      this.finishDialog})
      : super(key: key);

  @override
  _TemplateButtonState createState() => _TemplateButtonState();
}

class _TemplateButtonState extends State<TemplateButton> {
  @override
  Widget build(BuildContext context) {
    final Color buttonColor = widget.color ?? Constants.paleBlue;
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
                    color: buttonColor,
                    size: SizeConfig.blockSizeHorizontal * 8,
                  ),
            widget.title == null
                ? Container()
                : Text(
                    widget.title,
                    style: TextStyle(color: buttonColor, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
        color: widget.color == null ? Colors.white : Colors.white,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(12),
            side: BorderSide(color: Colors.white, width: 1)),
        onPressed: widget.ontap,
        focusColor: Colors.white,
        hoverColor: Colors.white70,
        splashColor: Colors.white,
        padding: EdgeInsets.all(10),

        //function to change selectedVar goes here
      ),
    );
  }
}
