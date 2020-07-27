// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/reminder.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/services/login_functions.dart';

class ReminderData {
  final db = Firestore.instance;
  final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();

  Future<String> createReminder(
      {String caption, String pictureUrl, DateTime postTime}) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .collection('reminders')
          .add({
        'caption': caption,
        'isPosted': false,
        'scheduled_image': pictureUrl,
        'date': "${postTime.day}/${postTime.month}/${postTime.year}",
        'postTime': postTime,
      });
      return ('Created Reminder');
    } catch (e) {
      print(e);
    }
  }

  Future<List<Reminder>> getReminders(DateTime date) async {
    try {
      List<Reminder> reminders = List<Reminder>();
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .collection('reminders')
          .where('date', isEqualTo: "${date.day}/${date.month}/${date.year}")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((reminder) {
          Reminder rem = Reminder(
              caption: reminder['caption'],
              isPosted: reminder['isPosted'],
              picture: Image.network(reminder['scheduled_image']),
              pictureUrl: reminder['scheduled_image'],
              postTime: reminder['postTime'].toDate(),
              date: reminder['date'],
              id: reminder.documentID);
          reminders.add(rem);
        });
      });
      return reminders;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Reminder>> getAllReminders() async {
    try {
      List<Reminder> reminders = List<Reminder>();
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .collection('reminders')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((reminder) {
          Reminder rem = Reminder(
              caption: reminder['caption'],
              isPosted: reminder['isPosted'],
              picture: Image.network(reminder['scheduled_image']),
              postTime: reminder['postTime'].toDate(),
              date: reminder['date'],
              pictureUrl: reminder['scheduled_image'],
              id: reminder.documentID);
          reminders.add(rem);
        });
      });
      return reminders;
    } catch (e) {
      print(e);
    }
  }

  Future<String> updateReminder(Reminder reminder) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .collection('reminders')
          .document(reminder.id)
          .updateData({
        'caption': reminder.caption,
        'isPosted': reminder.isPosted,
        'scheduled_image': reminder.pictureUrl,
        'date': reminder.date,
        'postTime': reminder.postTime,
      });
      return ('Updated Reminder');
    } catch (e) {
      print(e);
    }
  }

  Future<String> deleteReminder(Reminder reminder) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .collection('reminders')
          .document(reminder.id)
          .delete();
      return ('Deleted Reminder');
    } catch (e) {
      print(e);
    }
  }
}
