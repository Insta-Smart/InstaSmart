
import 'package:flutter/material.dart';

class CustomDialogWidget extends StatelessWidget {
  final String body, title;
  final Function action1, action2;

  final Function dialogCloseRoute;
  final String action1text, action2text;

  const CustomDialogWidget(
      {Key key,
        this.body,
        this.title,
        this.action1,
        this.action1text,
        this.action2text,
        this.action2,
        this.dialogCloseRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.88),
        title: Text(
          title,
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        content: Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Close',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: dialogCloseRoute ??
                    () {
                  Navigator.of(context).pop();
                },
          ),
          action1 == null
              ? null
              : FlatButton(
            child: Text(
              action1text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            onPressed: action1,
          ),
          action2 == null
              ? null
              : FlatButton(
              child: Text(
                action2text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              onPressed: action2),
        ]);
  }
}
