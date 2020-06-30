import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/user.dart';
import 'package:flutter/material.dart';

class LikingFunctions {
  final collectionRef = Firestore.instance.collection('allframessmall');
  final userRef = Firestore.instance.collection('Users');
  final FirebaseFunctions firebase = FirebaseFunctions();
  User user;

  void addImgToLiked(String id, String url) async {
    try {
      User user = await firebase.currentUser();
      await userRef
          .document(user.uid)
          .collection('LikedFrames')
          .document(id)
          .setData({
        'imgurl': url,
      });
      print('done adding img');
    } catch (e) {
      print('error in adding image: e');
    }
  }

  void delImgFromLiked(String id) async {
    try {
      User user = await firebase.currentUser();
      await userRef
          .document(user.uid)
          .collection('LikedFrames')
          .document(id)
          .delete();
      print('done deleting');
    } catch (e) {
      print(e);
    }
  }

  //INCREMENTS VALUE OF POPULARITY OF THIS IMAGE IN ALLFRAMESPNGURL COLLECTION
  void updateLikes(String givenURL, bool isLiked) {
    try {
      collectionRef.document(givenURL).updateData(
          {'popularity': FieldValue.increment(isLiked ? 1.0 : -1.0)});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> futInitLikedStat(String id) async {
    bool liked;
    try {
      User user = await firebase.currentUser();
      final snapshot = await userRef
          .document(user.uid)
          .collection('LikedFrames')
          .document(id)
          .get();
      if (snapshot.exists) {
        print('user liked frame');
        liked = true;
        print(liked);
      } else {
        print('user did not like frame');
        liked = false;
        print(liked);
      }
      print(liked);
      return liked;
    } catch (e) {
      print('error in getInitLikedStat is ${e}');
    }
  }

  bool getInitLikedStat(String id) {
    bool liked;
    futInitLikedStat(id).then((value) {
      liked = value;
      print('result of getInitLIkedstat: ${liked}');
      return liked;
    });
  }
}
