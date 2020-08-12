// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:instasmart/models/reminder.dart';

import '../mock_services/mock_reminder_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Reminder Data CRUD Operations:', () {
    String caption = 'Instasmart reminder test';
    String pictureUrl =
        'https://drive.google.com/uc?export=view&id=19sjeFM_bR70UE37Lpa9FUgClOA71dLv4';
    DateTime postTime = DateTime(2020, 4, 3, 3, 4);
    String email = 'test@gmail.com';
    String password = '1234567Q';

    var reminderData = MockReminderData();

    test('create new reminder', () async {
      var user = await reminderData.firebase
          .signInWithEmailAndPassword(email, password);
      String status = await reminderData.createReminder(
          caption: caption, pictureUrl: pictureUrl, postTime: postTime);

      final snapshot = await reminderData.db
          .collection('Users')
          .document(user.uid)
          .collection('reminders')
          .getDocuments();
      expect(snapshot.documents.first['scheduled_image'], pictureUrl);
      expect(status, 'Created Reminder');
    });

    test('get all reminders', () async {
      var reminders = await reminderData.getAllReminders();
      expect(reminders, isA<List<Reminder>>());
      expect(reminders.first.pictureUrl, pictureUrl);
    });

    test('get all reminders for a specific date', () async {
      var reminders = await reminderData.getReminders(postTime);
      expect(reminders, isA<List<Reminder>>());
      expect(reminders.first.pictureUrl, pictureUrl);
    });

    test('update reminder details', () async {
      var reminders = await reminderData.getReminders(postTime);
      expect(reminders.first.caption, caption);

      var newReminder = reminders.first;
      newReminder.caption = "Updated caption";

      String status = await reminderData.updateReminder(newReminder);
      var updatedReminders = await reminderData.getReminders(postTime);
      expect(updatedReminders.first.caption, "Updated caption");
      expect(status, 'Updated Reminder');
    });

    test('delete reminder', () async {
      var reminder = await reminderData.getReminders(postTime);
      String status = await reminderData.deleteReminder(reminder.first);
      var updatedReminders = await reminderData.getReminders(postTime);
      expect(updatedReminders.length, 0);
      expect(status, 'Deleted Reminder');
    });
  });
}
