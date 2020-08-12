// Flutter imports:
import 'package:flutter/material.dart';

class Reminder {
  Image picture;
  String pictureUrl;
  String caption;
  String date;
  DateTime postTime;
  bool isPosted;
  String id;

  Reminder(
      {this.picture,
      this.caption,
      this.postTime,
      this.date,
      this.isPosted = false,
      this.id,
      this.pictureUrl});

  void togglePosted() {
    isPosted = !isPosted;
  }
}
