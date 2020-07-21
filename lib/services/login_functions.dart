// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
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
    userRef.document(user.uid).get().then((value) {
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
      authResult.user.sendEmailVerification();
    } catch (e) {
      print("An error occured while trying to send email verification:");
      print(e.message);
    }
    try {
      User user = User(
        email: email,
        firstName: firstName,
        uid: authResult.user.uid,
        active: true,
        lastName: lastName,
        settings: Settings(allowPushNotifications: true),
      );
      MyAppState.currentUser = user;
      Map<String, String> userImMap = {'user_images': ''};
      Map finalMap = user.toJson();
      finalMap.addAll(userImMap);
      await db
          .collection(Constants.USERS)
          .document(currUser.uid)
          .setData(finalMap);
    } catch (e) {
      print('error in creating user with email');
      print(e.toString());
    }
    return MyAppState.currentUser;
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

      try {
        User user = User(
          email: currentUser.email,
          firstName: currentUser.displayName,
          uid: currentUser.uid,
          active: true,
          lastName: ' ',
          settings: Settings(allowPushNotifications: true),
        );
        print('user login data is:');
        print(user.toJson());
        Map<String, String> userImMap = {'user_images': ''};
        Map finalMap = user.toJson();
        finalMap.addAll(userImMap);
        bool userExists;
        await db
            .collection(Constants.USERS)
            .document(currentUser.uid)
            .get()
            .then((value) {
          userExists = value.exists;
        });
        if (!userExists) {
          await db
              .collection(Constants.USERS)
              .document(currentUser.uid)
              .setData(finalMap);
        }
        MyAppState.currentUser = user;
      } catch (e) {
        print('error in setting google sign in data' + e.toString());
      }

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
