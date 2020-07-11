// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import '../constants.dart';
import '../main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/services/Authenticate.dart';
import 'package:instasmart/utils/helper.dart';

class FirebaseLoginFunctions extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User currUser;
  final userRef = Firestore.instance.collection(Constants.USERS);

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }

    return User(
      uid: user.uid,
      email: user.email,
    );
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    currUser = _userFromFirebase(user);
    String firstName, lastName, signInMethod;
    await userRef.document(user.uid).get().then((value) {
      firstName = value["firstName"] ?? " ";
      lastName = value["lastName"] ?? " ";
      signInMethod = user.providerData[1].providerId;
    });

    return User(
        uid: user.uid,
        email: user.email,
        firstName: firstName,
        lastName: lastName,
        logInMethod: signInMethod);
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

    try {
      User user = User(
        email: email,
        firstName: firstName,
        uid: authResult.user.uid,
        active: true,
        lastName: lastName,
        settings: Settings(allowPushNotifications: true),
      );
      await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .document(authResult.user.uid)
          .setData(user.toJson());
      hideProgress();
      MyAppState.currentUser = user;

      await db
          .collection(Constants.USERS)
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
