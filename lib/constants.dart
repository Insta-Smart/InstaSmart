// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:instasmart/main.dart';
import 'main.dart';

class Constants {
  static Color brightPurple = Color(0xff8276D8);
  static Color darkPurple = Color(0xff635AA1);
  static Color deepBlue = Color(0xff0a4461);
  static Color paleBlue = Color(0xff95c5ee); //A3C5DE
  static Color palePink = Color(0xffDD8080);
  static Color lightPurple = Color(0xffAF97CA);
  // static const lightPurple = Color(0xff9575CD);
  static const double buttonHeight = 45;
  static const double buttonRadius = 20.0;
  static Image sampleUserPhoto = Image.network(
      "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_1.png?alt=media&token=09b3e728-6d01-4c07-a3c5-dbea4b0f9781");
  static Image sampleFrame = Image.network(
      "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_2.png?alt=media&token=7966740e-f042-4e7a-9ea2-1fcb561b5a8a");
  static ShapeBorder buttonShape =
      new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30));
  static const FINISHED_ON_BOARDING = 'finishedOnBoarding';
  static const COLOR_ACCENT = 0xFFd756ff;
  static const COLOR_PRIMARY_DARK = 0xFF6900be;
  static const COLOR_PRIMARY = 0xFFa011f2;
  static const FACEBOOK_BUTTON_COLOR = 0xFF415893;
  static const USERS = 'Users';
  static const ALL_FRAMES_COLLECTION = 'FramesUrls';
}
