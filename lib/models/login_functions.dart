import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instasmart/models/user.dart';

class FirebaseFunctions extends ChangeNotifier{

  final auth = FirebaseAuth.instance;
  User currUser;

    User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  Future<User> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    currUser = await _userFromFirebase(user);
    return _userFromFirebase(user);
  }

  Future<User> signInAnonymously() async {
    final AuthResult authResult = await auth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }


  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await auth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    currUser = await _userFromFirebase(authResult.user);
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await auth
        .createUserWithEmailAndPassword(email: email, password: password);
    currUser = await _userFromFirebase(authResult.user);
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

  Future<void> signOut() async{
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
}
