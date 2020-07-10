import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import 'reminder.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/user.dart';

class ReminderData {
  final db = Firestore.instance;
  final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();

  void createReminder(
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
      print('done creating');
    } catch (e) {
      print(e);
    }
  }

  Future<List<Reminder>> getReminders(DateTime date) async {
    try {
      List<Reminder> reminders = List<Reminder>();
      User user = await firebase.currentUser();
      await db
          .collection("Constants.USERS")
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
          .collection("Constants.USERS")
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
              picture_url: reminder['scheduled_image'],
              id: reminder.documentID);
          reminders.add(rem);
        });
      });
      return reminders;
    } catch (e) {
      print(e);
    }
  }

  void updateReminder(Reminder reminder) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection("Constants.USERS")
          .document(user.uid)
          .collection('reminders')
          .document(reminder.id)
          .updateData({
        'caption': reminder.caption,
        'isPosted': reminder.isPosted,
        'scheduled_image': reminder.picture_url,
        'date': reminder.date,
        'postTime': reminder.postTime,
      });
      print('done updating');
    } catch (e) {
      print(e);
    }
  }

  void deleteReminder(Reminder reminder) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection("Constants.USERS")
          .document(user.uid)
          .collection('reminders')
          .document(reminder.id)
          .delete();
      print('done deleting');
    } catch (e) {
      print(e);
    }
  }
}
