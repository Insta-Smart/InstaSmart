import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/size_config.dart';

import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/AuthScreen.dart';

import 'package:instasmart/screens/create_grid_screen.dart';

import 'package:instasmart/screens/frames_screen.dart';

import 'package:instasmart/utils/helper.dart';

import 'package:instasmart/main.dart';
import 'EditingSettingScreen.dart';
import 'HomeScreen.dart';
import 'SignUpScreen.dart';

import 'HomeScreen.dart';
import 'SignUpScreen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    Key key,
    this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userRef = Firestore.instance.collection('Users');
    final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();
    //User user = await firebase.currentUser();

    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 18, 0, 0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Hi ${user.firstName ?? 'there'}!',
                style: TextStyle(fontSize: 45, color: Constants.palePink),
              ),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 7),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        user.firstName == null
                            ? Text("Enter name",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16))
                            : Text(user.firstName + " " + user.lastName,
                                style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(
                            Icons.mode_edit,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSettings(user),
                                ));
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Email: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(user.email, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        splashColor: Colors.black,
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.help_outline),
                            Text("Need Help?", style: TextStyle(fontSize: 16))
                          ],
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        splashColor: Colors.black,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.black54,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          user.active = false;
                          user.lastOnlineTimestamp = Timestamp.now();
                          //      _fireStoreUtils.updateCurrentUser(user, context);
                          await FirebaseAuth.instance.signOut();
                          MyAppState.currentUser = null;
                          pushAndRemoveUntil(context, AuthScreen(), false);
                        },
                      ),
                    ],
                  )
                ],
              ),
            )

//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(user.uid),
//            ), //for reference only
            ,
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 4),
            ),
            Text("Get In Touch!\n orbital2k20@gmail.com",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
