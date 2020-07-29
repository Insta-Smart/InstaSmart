// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/constants.dart';

class PageTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs
  const PageTopBar({Key key, this.title, this.appBar, this.widgets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Constants.lightPurple),
      ),
      actions: widgets,
      iconTheme:
          IconThemeData(color: Constants.lightPurple //change your color here
              ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
