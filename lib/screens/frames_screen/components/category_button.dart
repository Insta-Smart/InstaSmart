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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: RaisedButton(
        elevation: widget.selectedCat == widget.catName ? 5 : 1,
        //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text("#" + widget.catName,
            style: widget.selectedCat == widget.catName
                ? TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    //fontWeight: FontWeight.w700
                  )
                : TextStyle(
                    color: Constants.paleBlue.withOpacity(1),
                    fontSize: 17,
                  )),
        color: widget.selectedCat == widget.catName
            ? Constants.lightPurple
            : Theme.of(context).scaffoldBackgroundColor,
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
