// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';

class FirebaseLoginFunctions extends ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userRef = Firestore.instance.collection(Constants.USERS);

  Future<User> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    String firstName, lastName;
    await userRef.document(user.uid).get().then((value) {
      firstName = value["firstName"];
      lastName = value["lastName"];
    });

    return User(
      uid: user.uid,
      email: user.email,
      firstName: firstName,
      lastName: lastName,

    );
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult =
        await auth.signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return currentUser();
  }

  Future<User> createUserWithEmailAndPassword(String email, String password,
      String firstName, String lastName, BuildContext context) async {
    final AuthResult authResult = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    try {
      authResult.user.sendEmailVerification();
    } catch (e) {
      print("An error occured while trying to send email verification:");
      print(e);
    }
    try {
      User user = User(
        email: email,
        firstName: firstName,
        uid: authResult.user.uid,
        active: true,
        lastName: lastName,
      );
      MyAppState.currentUser = user;
      Map<String, String> userImMap = {'user_images': ''};
      Map finalMap = user.toJson();
      finalMap.addAll(userImMap);
      await db.collection(Constants.USERS).document(user.uid).setData(finalMap);
      return MyAppState.currentUser;
    } catch (e) {
      print('error in creating user with email');
      print(e.toString());
      throw (e as PlatformException);
    }
  }

  Future<void> updateUserData(Map data) {
    db
        .collection(Constants.USERS)
        .document(MyAppState.currentUser.uid)
        .updateData(data);
    return null;
  }


  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await auth.signOut();
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

//  GoogleSignIn _googleSignIn = GoogleSignIn(
//    scopes: <String>[
//      'email',
//    ],
//  );

  Future<String> signInWithGoogle() async {
    try {
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

      final FirebaseUser currUser = await auth.currentUser();
      assert(user.uid == currUser.uid);

      try {
        User user = User(
          email: currUser.email,
          firstName: currUser.displayName,
          uid: currUser.uid,
          active: true,
          lastName: ' ',
        );
        print('user login data is:');
        print(user.toJson());
        Map<String, String> userImMap = {'user_images': ''};
        Map finalMap = user.toJson();
        finalMap.addAll(userImMap);
        bool userExists;
        await db
            .collection(Constants.USERS)
            .document(currUser.uid)
            .get()
            .then((value) {
          userExists = value.exists;
        });
        if (!userExists) {
          await db
              .collection(Constants.USERS)
              .document(currUser.uid)
              .setData(finalMap);
          MyAppState.currentUser = user;
        } else {
          currentUser().then((value) {
            MyAppState.currentUser = value;
          });
        }
      } catch (e) {
        print('error in setting google sign in data' + e.toString());
      }
      return 'signInWithGoogle succeeded: $user';


    } catch (e) {
      print("Google sign in error: $e");
    }
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }
}
