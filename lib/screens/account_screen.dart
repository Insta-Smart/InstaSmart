import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/size_config.dart';

import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/AuthScreen.dart';

import 'package:instasmart/utils/helper.dart';

import 'package:instasmart/main.dart';

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
    return Scaffold(
//      drawer: Drawer(
//        child: ListView(
//          padding: EdgeInsets.zero,
//          children: <Widget>[
//            DrawerHeader(
//              child: Text(
//                'InstaSmart',
//                style: TextStyle(color: Colors.white),
//              ),
//              decoration: BoxDecoration(
//                color: Constants.lightPurple,
//              ),
//            ),
//            ListTile(
//              title: Text(
//                'Logout',
//                style: TextStyle(color: Colors.black),
//              ),
//              leading: Transform.rotate(
//                  angle: pi / 1,
//                  child: Icon(Icons.exit_to_app, color: Colors.black)),
//              onTap: () async {
//                user.active = false;
//                user.lastOnlineTimestamp = Timestamp.now();
//                //      _fireStoreUtils.updateCurrentUser(user, context);
//                await FirebaseAuth.instance.signOut();
//                MyAppState.currentUser = null;
//                pushAndRemoveUntil(context, AuthScreen(), false);
//              },
//            ),
//          ],
//        ),
//      ),
//      appBar: AppBar(
//        title: Text(
//          'Profile',
//          style: TextStyle(color: Colors.black),
//        ),
//        backgroundColor: Colors.white,
//        centerTitle: true,
//      ),
      body: Container(
        padding:
            EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical * 15, 0, 0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hi ${user.firstName ?? 'there!'}',
              style: TextStyle(fontSize: 45),
            ),
            Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 9),
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

class EditSettings extends StatefulWidget {
  final User user;
  String firstName;
  String lastName;
  String password;
  String confirmPassword;
  bool passwordChanged;

  EditSettings(@required this.user);

  @override
  _EditSettingsState createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Create new account',
                style: TextStyle(
                    color: Color(Constants.COLOR_PRIMARY),
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              )),
          SignUpTextWidget(
            context: context,
            title: "First Name",
            onSave: (val) {
              widget.firstName = val;
            },
            textObscure: false,
          ),
          SignUpTextWidget(
            context: context,
            title: "Last Name",
            onSave: (val) {
              widget.lastName = val;
            },
            textObscure: false,
          ),
          SignUpTextWidget(
            context: context,
            title: "Password",
            onSave: (val) {
              widget.password = val.trim();
            },
            Validator: validatePassword,
            Controller: _passwordController,
            textObscure: true,
          ),
          SignUpTextWidget(
            context: context,
            title: "Confirm Password",
            onSave: (val) {
              widget.confirmPassword = val.trim();
            },
            Validator: (val) =>
                validateConfirmPassword(_passwordController.text, val),
            onfieldsubmitted: (_) {
              updateServer();
            },
            textObscure: true,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                color: Color(Constants.COLOR_PRIMARY),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                splashColor: Color(Constants.COLOR_PRIMARY),
                onPressed: () {
                  updateServer().then(_showMyDialog());
                },
                padding: EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color(Constants.COLOR_PRIMARY))),
              ),
            ),
          ),
        ],
      )),
    );
  }

  updateServer() async {
    //change name
    final userRef = Firestore.instance.collection('${Constants.USERS}');
    _changePassword(String password) async {
      //Create an instance of the current user.
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      //Pass in the password to updatePassword.
      user.updatePassword(password).then((_) {
        print("Succesfull changed password");
      }).catchError((error) {
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }

    widget.passwordChanged ? _changePassword(widget.password) : () {};
    //change name

    await userRef.document(widget.user.uid).updateData(
        {"firstName": widget.firstName, "lastName": widget.lastName});
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Saved changes'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  //TODO: Pop here
                }
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => AccountScreen(),
//                    ));
//              },
                ),
          ],
        );
      },
    );
  }
}
