//import 'package:meta/meta.dart';
//
////class User {
////   User({
////    @required this.uid,
////    this.email,
////    this.photoUrl,
////    this.displayName,
////  });
////
////  final String uid;
////  final String email;
////  final String photoUrl;
////  final String displayName;
////}
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email = ' ';
  String firstName = ' ';
  String lastName = ' ';
  Settings settings = Settings(allowPushNotifications: true);
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String uid;
  bool selected = false;
  String appIdentifier = 'Flutter ${Platform.operatingSystem}';
  bool GoogleSignIn = false;

  User({
    this.email,
    this.firstName,
    //    this.phoneNumber,
    this.lastName,
    this.active,
    this.lastOnlineTimestamp,
    this.settings,
    this.uid,
//      this.profilePictureURL
  });

  String fullName() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      email: parsedJson['email'] ?? "",
      firstName: parsedJson['firstName'] ?? '',
      lastName: parsedJson['lastName'] ?? '',
      active: parsedJson['active'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: Settings.fromJson(
          parsedJson['settings'] ?? {'allowPushNotifications': true}),
      //phoneNumber: parsedJson['phoneNumber'] ?? "",
      uid: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      //  profilePictureURL: parsedJson['profilePictureURL'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "settings": this.settings.toJson(),
      // "phoneNumber": this.phoneNumber,
      "id": this.uid,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      // "profilePictureURL": this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}

class Settings {
  bool allowPushNotifications = true;

  Settings({this.allowPushNotifications});

  factory Settings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Settings(
        allowPushNotifications: parsedJson['allowPushNotifications'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'allowPushNotifications': this.allowPushNotifications};
  }
}
