// Package imports:
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/services/liking_functions.dart';
import 'package:instasmart/services/login_functions.dart';
import 'mock_login_functions.dart';

class MockLikingFunctions extends LikingFunctions{
  static final instance = MockFirestoreInstance();
  @override
  final collectionRef =
  instance.collection(Constants.ALL_FRAMES_COLLECTION);
  @override
  final userRef = instance.collection(Constants.USERS);
  @override
  final FirebaseLoginFunctions firebase = MockFirebaseLoginFunctions();

}
