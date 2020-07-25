// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/models/user.dart';


class LikingFunctions {
  static final instance = Firestore.instance;
  final collectionRef =
      instance.collection(Constants.ALL_FRAMES_COLLECTION);
  final userRef = instance.collection(Constants.USERS);

  final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();
  User user;

  void addImgToLiked(String id, String lowResUrl, String highResUrl) async {
    try {
      user = await firebase.currentUser();
      await userRef
          .document(user.uid)
          .collection('LikedFrames')
          .document(id)
          .setData({
        'lowResUrl': lowResUrl,
        'highResUrl': highResUrl,
      });
      print('done adding img');
    } catch (e) {
      print('error in adding image: e');
    }
  }

  void delImgFromLiked(String id) async {
    try {
      user = await firebase.currentUser();
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

  //INCREMENTS/DECREMENTS VALUE OF POPULARITY OF THIS IMAGE IN ALLFRAMESPNGURL COLLECTION
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
        // print('user liked frame');
        liked = true;
        // print(liked);
      } else {
        // print('user did not like frame');
        liked = false;
        // print(liked);
      }
      //  print(liked);
      return liked;
    } catch (e) {
      print('error in getInitLikedStat is ${e}');
    }
  }

}
