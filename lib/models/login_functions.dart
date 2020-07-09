import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instasmart/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instasmart/services/Authenticate.dart';
import 'package:instasmart/utils/helper.dart';

import '../constants.dart';
import '../main.dart';

class FirebaseFunctions extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User currUser;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
//      displayName: user.displayName,
//      photoUrl: user.photoUrl,
    );
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    currUser = _userFromFirebase(user);
    return _userFromFirebase(user);
  }

  Future<User> signInAnonymously() async {
    final AuthResult authResult = await auth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult =
        await auth.signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    currUser = _userFromFirebase(authResult.user);
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(String email, String password,
      String firstName, String mobile, String lastName) async {
    final AuthResult authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    currUser = _userFromFirebase(authResult.user);
    var profilePicUrl = '';
//        AuthResult result = await FirebaseAuth.instance
//            .createUserWithEmailAndPassword(email: email, password: password);

//        if (_image != null) {
//          updateProgress('Uploading image, Please wait...');
//          profilePicUrl = await FireStoreUtils()
//              .uploadUserImageToFireStorage(_image, result.user.uid);
//        }

    try {
      User user = User(
        email: email,
        firstName: firstName,
        //phoneNumber: mobile,
        uid: authResult.user.uid,
        active: true,
        lastName: lastName,
        settings: Settings(allowPushNotifications: true),
        //   profilePictureURL: profilePicUrl
      );
      await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .document(authResult.user.uid)
          .setData(user.toJson());
      hideProgress();
      MyAppState.currentUser = user;

      await db
          .collection("Constants.USERS")
          .document(currUser.uid)
          .setData({'user_images': ''});
    } catch (e) {
      print(e.toString());
    }
    return _userFromFirebase(authResult.user);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<User> signInWithEmailAndLink({String email, String link}) async {
    final AuthResult authResult =
        await auth.signInWithEmailAndLink(email: email, link: link);
    return _userFromFirebase(authResult.user);
  }

  Future<bool> isSignInWithEmailLink(String link) async {
    return await auth.isSignInWithEmailLink(link);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Stream<User> get onAuthStateChanged {
    return auth.onAuthStateChanged.map(_userFromFirebase);
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.{8,})(?=.*[A-Z])(?=.*[0-9])'; //Minimum 8 characters with atleast 1 Uppercase and 1 Numeric character
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  Future<String> signInWithGoogle() async {
    try {
//      try {
//        await _googleSignIn.signIn();
//      } catch (error) {
//        print(error);
//      }
//    }

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      currUser = _userFromFirebase(currentUser);

      return 'signInWithGoogle succeeded: $user';
    } catch (e) {
      print("Google sign in error: ${e}");
    }
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
