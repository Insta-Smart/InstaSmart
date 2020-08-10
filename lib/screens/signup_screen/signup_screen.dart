// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/services/login_functions.dart';
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
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        SignUpTextWidget(
          context: context,
          title: "First Name",
          validator: validateFirstName,
          prefixIcon: Icon(Icons.person,color:Theme.of(context).focusColor),
          onSave: (val) {
            firstName = val.trim();
          },
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Last Name",
          validator: validateLastName,
          prefixIcon: Icon(Icons.person,color:Theme.of(context).focusColor),
          onSave: (val) {
            lastName = val.trim();
          },
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Email Address",
          prefixIcon: Icon(Icons.email, color: Theme.of(context).focusColor,),
          onSave: (String val) {
            email = val.trim().replaceAll(' ', '');
          },
          validator: validateEmail,
          textObscure: false,
        ),
        SignUpTextWidget(
          context: context,
          title: "Password",
          prefixIcon: Icon(Icons.lock, color:Theme.of(context).focusColor),
          onSave: (val) {
            password = val.trim();
          },
          validator: validatePassword,
          controller: _passwordController,
          textObscure: true,
        ),
        SignUpTextWidget(
          context: context,
          title: "Confirm Password",
          prefixIcon: Icon(Icons.lock, color:Theme.of(context).focusColor),
          onSave: (val) {
            confirmPassword = val.trim();
          },
          validator: (val) =>
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
              color: Theme.of(context).primaryColor,
              child: Text(
                'Create Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textColor: Colors.white,
              splashColor: Theme.of(context).primaryColor,
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
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

      FirebaseLoginFunctions()
          .createUserWithEmailAndPassword(
              email, password, firstName, lastName, context)
          .then((value) {
        hideProgress();
        pushAndRemoveUntil(context, HomeScreen(), false);
      }).catchError((error) {
        hideProgress();
        print("error in sign up:");
        (error as PlatformException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'Failed', 'Couldn\'t sign up')
            : showAlertDialog(context, 'Failed',
                'Email already in use, Please pick another email!');
        print(error.toString());
      });
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
      this.validator,
      this.controller,
      this.textObscure,
      this.maxLength,
      this.prefixIcon})
      : super(key: key);

  final BuildContext context;
  final Function onSave;
  final String title;
  final Function onfieldsubmitted;
  final Function validator;
  final bool textObscure;
  final TextEditingController controller;
  final int maxLength;
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
                validator: validator,
                onSaved: (String val) {
                  onSave(val);
                },
                keyboardType: title == "Email Address"
                    ? TextInputType.emailAddress
                    : null,
                obscureText: textObscure,
                controller: controller,
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
                            color: Theme.of(context).primaryColor, width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )))));
  }
}
