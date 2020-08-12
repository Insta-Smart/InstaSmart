// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/utils/size_config.dart';
import './components/help_sections.dart';

//url ref:https://github.com/TheAlphamerc/flutter_smart_course

class HelpScreen extends StatelessWidget {
  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  List<Widget> _courseList() {
    return List.generate(CourseList.list.length, (index) {
      return Column(children: <Widget>[
        _courseInfo(CourseList.list[index],
            _decorationContainerA(Colors.redAccent, -110, -85),
            background: Constants.paleBlue),
        Divider(
          thickness: 1,
          endIndent: 20,
          indent: 20,
        )
      ]);
    });
  }

  Widget _courseInfo(CourseModel model, Widget decoration, {Color background}) {
    return Container(
        padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 6,
            right: SizeConfig.blockSizeHorizontal * 3),
        width: SizeConfig.blockSizeHorizontal * 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 4),
                          child: Text(model.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Icon(model.symbol),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(width: 10)
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(model.description,
                      style: TextStyle(
                          fontSize: 16,
                          color: Constants.darkPurple,
                          height: 1.5)),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      _chip(model.tag1, Constants.lightPurple, height: 5),
                      SizedBox(
                        width: 10,
                      ),
                      _chip(model.tag2, Constants.palePink, height: 5),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 15),
      ),
    );
  }

  Widget _decorationContainerA(Color primaryColor, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.orange,
          ),
        ),
        _smallContainer(Colors.yellow, 40, 20),
        Positioned(
          top: -30,
          right: -10,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        ),
        Positioned(
          top: 110,
          right: -50,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Constants.darkPurple,
            child:
                CircleAvatar(radius: 40, backgroundColor: Constants.paleBlue),
          ),
        ),
      ],
    );
  }

  Positioned _smallContainer(Color primaryColor, double top, double left,
      {double radius = 10}) {
    return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withAlpha(255),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          appBar: PageTopBar(
            appBar: AppBar(),
            title: 'Help',
          ),
          body: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 2),
            ),
            Text(
              'Learn How To InstaSmart Your Instagram',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: _courseList(),
              ),
            ),
          ])),
    );
  }
}
