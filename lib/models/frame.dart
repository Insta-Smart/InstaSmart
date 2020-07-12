// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:meta/meta.dart';

class Frame {
  String lowResUrl;
  String highResUrl;
  String imgID;
  String category;

  Frame({this.imgID, this.category, this.lowResUrl, this.highResUrl});
}
