// Package imports:
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

// Project imports:
import 'package:instasmart/services/firebase_image_storage.dart';
import 'mock_login_functions.dart';

class MockFirebaseImageStorage extends FirebaseImageStorage {
  @override
  final StorageReference reference = MockFirebaseStorage().ref();
  @override
  final instance = MockFirebaseStorage();
  @override
  final db = MockFirestoreInstance();
  @override
  final MockFirebaseLoginFunctions firebase = MockFirebaseLoginFunctions();
}
