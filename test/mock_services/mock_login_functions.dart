// Package imports:
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

// Project imports:
import 'package:instasmart/services/login_functions.dart';

class MockFirebaseLoginFunctions extends FirebaseLoginFunctions {
  @override
  final auth = MockFirebaseAuth();

  @override
  final db = MockFirestoreInstance();

  @override
  final googleSignIn = MockGoogleSignIn();

  @override
  final userRef = MockFirestoreInstance().collection('Users');
}
