import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Constants {
  static const brightPurple = Color(0xff8276D8);
  static const darkPurple = Color(0xff635AA1);
  //static const paleBlue = Color(0xffA3C5DE);
  static const paleBlue = Color(0xff95c5ee); //A3C5DE
  static const palePink = Color(0xffDF6666);
  static const lightPurple = Color(0xffAF97CA);
  // static const lightPurple = Color(0xff9575CD);
  static const double buttonHeight = 45;
  static const double buttonRadius = 20.0;
  static Image sampleUserPhoto = Image.network(
      "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_1.png?alt=media&token=09b3e728-6d01-4c07-a3c5-dbea4b0f9781");
  static Image sampleFrame = Image.network(
      "https://firebasestorage.googleapis.com/v0/b/instasmart-6df7d.appspot.com/o/testing_overlay%2Fsample_2.png?alt=media&token=7966740e-f042-4e7a-9ea2-1fcb561b5a8a");
}
