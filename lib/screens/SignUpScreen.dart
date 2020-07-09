import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/services/Authenticate.dart';
import 'package:instasmart/utils/helper.dart';

import '../constants.dart';
import 'package:instasmart/main.dart';

File _image;

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String firstName, lastName, email, mobile, password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      //retrieveLostData();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Create new account',
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
        SignUpTextWidget(
          context: context,
          title: "Email Address",
          onSave: (String val) {
            email = val.trim();
          },
          Validator: validateEmail,
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Password",
          onSave: (val) {
            password = val.trim();
          },
          Validator: validatePassword,
          Controller: _passwordController,
          textObscure: true,
        ),
        SignUpTextWidget(
          context: context,
          title: "Confirm Password",
          onSave: (val) {
            confirmPassword = val.trim();
          },
          Validator: (val) =>
              validateConfirmPassword(_passwordController.text, val),
          onfieldsubmitted: (_) {
            _sendToServer();
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
                'Sign Up',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: Color(Constants.COLOR_PRIMARY),
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Constants.lightPurple)),
            ),
          ),
        ),
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Creating new account, Please wait...', false);
      var profilePicUrl = '';
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        User user = User(
          email: email,
          firstName: firstName,
          uid: result.user.uid,
          active: true,
          lastName: lastName,
          settings: Settings(allowPushNotifications: true),
        );
        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .document(result.user.uid)
            .setData(user.toJson());
        hideProgress();
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, HomeScreen(user: user), false);
      } catch (error) {
        hideProgress();
        (error as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'Failed', 'Couldn\'t sign up')
            : showAlertDialog(context, 'Failed',
                'Email already in use, Please pick another email!');
        print(error.toString());
      }
    } else {
      print('false');
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }
}

class SignUpTextWidget extends StatelessWidget {
  const SignUpTextWidget(
      {Key key,
      @required this.context,
      this.onSave,
      this.title,
      this.onfieldsubmitted,
      this.Validator,
      this.Controller,
      this.textObscure,
      this.MaxLength})
      : super(key: key);

  final BuildContext context;
  final Function onSave;
  final String title;
  final Function onfieldsubmitted;
  final Function Validator;
  final bool textObscure;
  final TextEditingController Controller;
  final int MaxLength;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
                maxLength:
                    title == "First Name" || title == "Last Name" ? 15 : null,
                validator: Validator,
                onSaved: (String val) {
                  onSave(val);
                },
                keyboardType: title == "Email Address"
                    ? TextInputType.emailAddress
                    : null,
                obscureText: textObscure,
                controller: Controller,
                textInputAction:
                    textObscure ? TextInputAction.done : TextInputAction.next,
                onFieldSubmitted: onfieldsubmitted ??
                    (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    contentPadding:
                        new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    fillColor: Colors.white,
                    hintText: title,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: Constants.lightPurple, width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    )))));
  }
}
