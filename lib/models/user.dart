
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String firstName;
  String lastName;
  Settings settings = Settings(allowPushNotifications: true);
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String uid;
  bool selected = false;
  String appIdentifier = 'Flutter ${Platform.operatingSystem}';

  User({
    this.email,
    this.firstName,
    this.lastName,
    this.active,
    this.lastOnlineTimestamp,
    this.settings,
    this.uid,
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
      uid: parsedJson['id'] ?? parsedJson['userID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "settings": this.settings.toJson(),
      "id": this.uid,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'appIdentifier': this.appIdentifier
    };
  }

  void changeFirstName(String newFirstName) {
    firstName = newFirstName;
  }

  void changeLastName(String newLastName) {
    lastName = newLastName;
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
