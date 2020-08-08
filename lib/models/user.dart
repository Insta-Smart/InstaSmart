// Dart imports:
import 'dart:io';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String firstName;
  String lastName;
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String uid;
  bool darkMode = false;
  String appIdentifier = 'Flutter ${Platform.operatingSystem}';

  User({
    this.email,
    this.firstName,
    this.lastName,
    this.active,
    this.darkMode,
    this.lastOnlineTimestamp,
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
      darkMode: parsedJson['darkMode'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      uid: parsedJson['id'] ?? parsedJson['userID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "firstName": this.firstName,
      "lastName": this.lastName,
      // "settings": this.settings.toJson(),
      "id": this.uid,
      'active': this.active,
      'darkMode': this.darkMode,
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
  void toggleDark(){
    darkMode=!darkMode;
  }
}


