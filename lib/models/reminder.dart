import 'package:flutter/material.dart';
class Reminder {
  Image picture;
  String caption;
  DateTime postTime;
  bool isPosted;

  Reminder({this.picture, this.caption, this.postTime, this.isPosted = false});

  void togglePosted() {
    isPosted = !isPosted;
  }
}