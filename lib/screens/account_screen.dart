import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';

import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/AuthScreen.dart';

import 'package:instasmart/utils/helper.dart';

import 'package:instasmart/main.dart';
import 'package:instasmart/widgets/template_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'InstaSmart',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Constants.lightPurple,
              ),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              leading: Transform.rotate(
                  angle: pi / 1,
                  child: Icon(Icons.exit_to_app, color: Colors.black)),
              onTap: () async {
                user.active = false;
                user.lastOnlineTimestamp = Timestamp.now();
                //      _fireStoreUtils.updateCurrentUser(user, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, AuthScreen(), false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: user.firstName == null
                  ? Text("Name: Enter name")
                  : user.firstName,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                child: FlatButton(
                  child: Text("Edit"),
                  onPressed: () {},
                )),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(user.uid), //For our reference only
//            ),
          ],
        ),
      ),
    );
  }
}
