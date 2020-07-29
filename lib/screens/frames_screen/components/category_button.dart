// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/HomeScreen.dart';

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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Stack(
          children: <Widget>[
//            RaisedButton(
//                elevation: widget.selectedCat == widget.catName ? 5 : 1,
//                //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                child: Text(
//                  "#" + widget.catName,
//                  style: TextStyle(color: Colors.white, fontSize: 17),
//                ),
//                color: Colors.white,
//                shape: Constants.buttonShape,
//                onPressed: widget.ontap
//                //function to change selectedVar goes here
//                ),
            GestureDetector(
              //elevation: 0,
              // elevation: widget.selectedCat == widget.catName ? 5 : 1,
              //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("#" + widget.catName,
                    style: widget.selectedCat == widget.catName
                        ? TextStyle(
                            color: Constants.lightPurple,
                            fontSize: 22,
                          )
                        : TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 16,
                          )),
              ),
              onTap: widget.ontap,
//              color: Colors.transparent,
////              color: widget.selectedCat == widget.catName
////                  ? Constants.lightPurple
////                  : Theme.of(context).backgroundColor,
//              shape: Constants.buttonShape,
//              onPressed: widget.ontap,
//              focusColor: Constants.brightPurple,
//              hoverColor: Constants.lightPurple,
//              splashColor: Constants.lightPurple,

              //function to change selectedVar goes here
            ),
          ],
        ));
  }
}
