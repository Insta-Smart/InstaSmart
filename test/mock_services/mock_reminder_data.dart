// Package imports:
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';

// Project imports:
import 'package:instasmart/services/reminder_data.dart';
import 'mock_login_functions.dart';

class MockReminderData extends ReminderData {
  @override
  final db = MockFirestoreInstance();

  @override
  final MockFirebaseLoginFunctions firebase = MockFirebaseLoginFunctions();
}
