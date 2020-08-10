// Flutter imports:
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/components/page_top_bar.dart';
import 'package:instasmart/components/template_button.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/utils/size_config.dart';

import './components/order_element.dart';

class PostOrderScreen extends StatelessWidget {
  PostOrderScreen(this.imgBytes, this.user);
  final List<Uint8List> imgBytes;
  final User user;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: PageTopBar(
          title: '',
          appBar: AppBar(),
          widgets: <Widget>[],
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.touch_app,
                  color: Theme.of(context).primaryColor,
                  size: 46,
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.8,
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  child: Text(
                    'Tap & Upload Each Photo In Order',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.looks_one,
                  color: Theme.of(context).primaryColor,
                ),
                Icon(
                  Icons.arrow_forward,
                ),
                Icon(Icons.looks),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 5,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                  imgBytes.length,
                  (index) => OrderElement(
                    imgBytes: imgBytes,
                    index: index,
                  ),
                ),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 25,
              child: TemplateButton(
                title: 'Done',
                color: Theme.of(context).primaryColor,
                ontap: () {
                  //  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
