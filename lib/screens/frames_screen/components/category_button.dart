// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/constants.dart';

class CategoryButton extends StatefulWidget {
  final String catName;
  final Function ontap;
  final String selectedCat;

  const CategoryButton(
      {Key key,
        @required this.catName,
        @required this.ontap,
        @required this.selectedCat})
      : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
      child: RaisedButton(
        elevation: 0,
        //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text("#" + widget.catName,
            style: widget.selectedCat == widget.catName
                ? TextStyle(
                color: Constants.paleBlue,
                fontSize: 17,
                fontWeight: FontWeight.w700)
                : TextStyle(
              color: Constants.lightPurple,
              fontSize: 17,
            )),
        color: widget.selectedCat == widget.catName
            ? Colors.transparent
            : Colors.transparent,
        shape: Constants.buttonShape,
        onPressed: widget.ontap,
        focusColor: Constants.brightPurple,
        hoverColor: Colors.white,
        splashColor: Constants.lightPurple,

        //function to change selectedVar goes here
      ),
    );
  }
}
