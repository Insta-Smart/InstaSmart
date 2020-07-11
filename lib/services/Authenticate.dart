// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/utils/helper.dart';

class FireStoreUtils {
  static Firestore firestore = Firestore.instance;
  static DocumentReference currentUserDocRef = firestore
      .collection(Constants.USERS)
      .document(MyAppState.currentUser.uid);
  StorageReference storage = FirebaseStorage.instance.ref();

  Future<User> getCurrentUser(String uid) async {
    DocumentSnapshot userDocument =
        await firestore.collection(Constants.USERS).document(uid).get();
    if (userDocument != null && userDocument.exists) {
      return User.fromJson(userDocument.data);
    } else {
      return null;
    }
  }

  Future<User> updateCurrentUser(User user, BuildContext context) async {
    return await firestore
        .collection(Constants.USERS)
        .document(user.uid)
        .setData(user.toJson())
        .then((document) {
      return user;
    }, onError: (e) {
      print(e);
      showAlertDialog(context, 'Error', 'Failed to Update, Please try again.');
      return null;
    });
  }

  Future<String> uploadUserImageToFireStorage(File image, String userID) async {
    StorageReference upload = storage.child("images/$userID.png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }
}
