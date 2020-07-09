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
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/screens/SignUpScreen.dart';
import 'package:instasmart/screens/create_grid_screen.dart';
import 'package:instasmart/screens/frames_screen.dart';

import 'package:instasmart/utils/helper.dart';

import 'package:instasmart/main.dart';

class EditSettings extends StatefulWidget {
  final User user;

  EditSettings(@required this.user);

  @override
  _EditSettingsState createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String firstName, lastName, password, confirmPassword;
  bool passwordChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PageTopBar(
          title: "Settings",
          appBar: AppBar(),
        ),
        body: Container(
          child: new Form(
              key: _key,
              autovalidate: _validate,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Edit Settings',
                        style: TextStyle(
                            color: Constants.lightPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      )),
                  SignUpTextWidget(
                    context: context,
                    title: "First Name",
                    onSave: (val) {
                      firstName = val;
                      print('sign in method is: ${widget.user.logInMethod}');
                    },
                    textObscure: false,
                  ),
                  SignUpTextWidget(
                    context: context,
                    title: "Last Name",
                    onSave: (val) {
                      lastName = val;
                    },
                    textObscure: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40.0, left: 40.0, top: 40.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                        color: Constants.lightPurple,
                        child: Text(
                          'Save',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                        splashColor: Constants.lightPurple,
                        onPressed: () async {
                          await updateServer().then(_showMyDialog());
//); //TODO: Error here: Unhandled Exception: type 'Future<void>' is not a subtype of type '(dynamic) => dynamic' of 'f'
                        },
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Constants.lightPurple)),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }

  updateServer() async {
    _key.currentState.save();
    showProgress(context, 'Updating settings, Please wait...', false);
    //change name
    try {
      final userRef = Firestore.instance.collection('${Constants.USERS}');
      //change name
      print("new name is: ${firstName}");
      await userRef
          .document(widget.user.uid)
          .updateData({"firstName": firstName, "lastName": lastName});
      widget.user.changeFirstName(firstName);
      widget.user.changeLastName(
          lastName); //changing locally so dont have to call firebase
    } catch (e) {
      print("error in updating settings is: ${e}");
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialogWidget(
            title: 'Saved!',
            body: 'Changes have been saved',
            DialogCloseRoute: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(index: 4, user: widget.user),
                  ));
            }
//                  var nav = Navigator.of(context);
//                  nav.pop(context);
//                  nav.pop(context);
//
            //}
            );
      },
    );
  }
}
