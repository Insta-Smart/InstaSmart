// Flutter imports:
import 'package:flutter/material.dart';

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
      backgroundColor: Theme.of(context).bottomAppBarColor,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
