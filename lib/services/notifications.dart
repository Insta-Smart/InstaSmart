// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instasmart/screens/HomeScreen.dart';

class LocalNotifications {
  LocalNotifications(this.context);
  BuildContext context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> scheduleNotification(DateTime postTime) async {
    int id = int.parse(
        "${postTime.month}${postTime.day}${postTime.hour}${postTime.minute}");
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'Channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'InstaSmart');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(id, 'Post Reminder',
        'Its time to post your photo!', postTime, notificationDetails);
  }

  Future<void> cancelNotification(DateTime postTime) async {
    int id = int.parse(
        "${postTime.month}${postTime.day}${postTime.hour}${postTime.minute}");
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future onSelectNotification(String payLoad) async {
    if (payLoad != null) {
      print(payLoad);
    }
    print('calendar test');
    Navigator.pushNamed(context, '/calender');
//    Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(
//            settings: RouteSettings(name: CalendarScreen.routeName),
//            builder: (context) =>
//                CalendarScreen()),(Route<dynamic> route) => false);
//     Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(
//            builder: (context) => HomeScreen(
//                  index: 3,
//                )),
//        (Route<dynamic> route) => false);

    print('calendar test done');

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay!")),
      ],
    );
  }
}
