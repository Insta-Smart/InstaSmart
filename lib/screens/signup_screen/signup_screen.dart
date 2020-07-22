// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:instasmart/services/login_functions.dart';

// Project imports:
import 'components/VerifyEmailScreen.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/utils/helper.dart';

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
            child: Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: Color(Constants.COLOR_PRIMARY),
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0),
              ),
            )),
        SizedBox(height: 20,),
        SignUpTextWidget(
          context: context,
          title: "First Name",
          prefixIcon: Icon(Icons.person),
          onSave: (val) {
            firstName = val.trim();
          },
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Last Name",
          prefixIcon: Icon(Icons.person),
          onSave: (val) {
            lastName = val.trim();
          },
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Email Address",
          prefixIcon: Icon(Icons.email),
          onSave: (String val) {
            email = val.trim().replaceAll(' ', '');
          },
          Validator: validateEmail,
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Password",
          prefixIcon: Icon(Icons.lock),
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
          prefixIcon: Icon(Icons.lock),
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
                'Create Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: Color(Constants.COLOR_PRIMARY),
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Color(Constants.COLOR_PRIMARY),),),
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

      try {
        FirebaseLoginFunctions()
            .createUserWithEmailAndPassword(
                email, password, firstName, lastName)
            .then((value) {
              hideProgress();
          pushAndRemoveUntil(context, HomeScreen(user: value), false);
        });
      } catch (error) {
        hideProgress();
        print("error in sign up:");
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
      this.MaxLength,
      this.prefixIcon})
      : super(key: key);

  final BuildContext context;
  final Function onSave;
  final String title;
  final Function onfieldsubmitted;
  final Function Validator;
  final bool textObscure;
  final TextEditingController Controller;
  final int MaxLength;
  final Icon prefixIcon;

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
                    prefixIcon: prefixIcon,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                            color: Color(Constants.COLOR_PRIMARY), width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )))));
  }
}
