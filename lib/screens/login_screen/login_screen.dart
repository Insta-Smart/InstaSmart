// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

// Project imports:
import '../HomeScreen.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/services/Authenticate.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/utils/helper.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Container(
        child: Form(
          key: _key,
          autovalidate: _validate,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Color(Constants.COLOR_PRIMARY),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                  child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      onSaved: (String val) {
                        email = val.trim();
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                      controller: _emailController,
                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Color(Constants.COLOR_PRIMARY),
                      decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.only(left: 16, right: 16),
                          fillColor: Colors.white,
                          hintText: 'Enter your Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(Constants.COLOR_PRIMARY),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(Constants.COLOR_PRIMARY),
                                  width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                  child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      validator: validatePassword,
                      onSaved: (String val) {
                        email = val.trim().replaceAll(' ', '');
                      },
                      onFieldSubmitted: (password) async {
                        await onClick(
                            _emailController.text, _passwordController.text);
                      },
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18.0),
                      obscureText: true,
                      cursorColor: Color(Constants.COLOR_PRIMARY),
                      decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.only(left: 16, right: 16),
                          fillColor: Colors.white,
                          hintText: 'Enter your Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(Constants.COLOR_PRIMARY),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Color(Constants.COLOR_PRIMARY),
                                  width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                ),
              ),
              FlatButton(
                child: Text('Forgot Password?'),
                onPressed: () => _resetDialogBox(),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: RaisedButton(
                    color: Color(Constants.COLOR_PRIMARY),
                    child: Text(
                      'Log In',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    textColor: Colors.white,
                    splashColor: Color(Constants.COLOR_PRIMARY),
                    onPressed: () async {
                      await onClick(
                          _emailController.text, _passwordController.text);
                    },
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side:
                            BorderSide(color: Color(Constants.COLOR_PRIMARY))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'OR',
                    style: TextStyle(color: Color(Constants.COLOR_PRIMARY)),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: RaisedButton.icon(
                    label: Text(
                      'Sign In With Google',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Image.asset(
                        'assets/images/google-logo.png',
                        //color: Colors.white,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    color: Colors.white,
                    textColor: Color(Constants.COLOR_PRIMARY),
                    splashColor: Constants.paleBlue,
                    onPressed: () async {
                      FirebaseLoginFunctions()
                          .signInWithGoogle()
                          .whenComplete(() async {
                        User user =
                            await FirebaseLoginFunctions().currentUser();
                        pushAndRemoveUntil(
                            context, HomeScreen(user: user), false);
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onClick(String email, String password) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Logging in, please wait...', false);
      User user =
          await loginWithUserNameAndPassword(email.trim(), password.trim());
      if (user != null)
        pushAndRemoveUntil(context, HomeScreen(user: user), false);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

<<<<<<< HEAD
  @override

=======
>>>>>>> 222b677b91b4721275591b31e919daf69a5a0687
  Future<User> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
//      if (!result.user.isEmailVerified) {
//        print('unverified email');
//        throw ('EMAIL_NOT_VERIFIED');
      // }

      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .document(result.user.uid)
          .get();
      User user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data);
        user.active = true;
        //remove this line as trial -->// await _fireStoreUtils.updateCurrentUser(user, context);
        hideProgress();
        MyAppState.currentUser = user;
      }
      print("got user");
      return user;
    } catch (exception) {
      hideProgress();
      if (exception == 'EMAIL_NOT_VERIFIED') {
        showAlertDialog(context, 'Email not verified', 'please verify email');
      } else {
        switch ((exception as PlatformException).code) {
          case 'ERROR_INVALID_EMAIL':
            showAlertDialog(context, 'Couldn\'t Authinticate',
                'email address is malformed');
            break;
          case 'ERROR_WRONG_PASSWORD':
            showAlertDialog(
                context, 'Couldn\'t Authinticate', 'wrong password');
            break;
          case 'ERROR_USER_NOT_FOUND':
            showAlertDialog(context, 'Couldn\'t Authinticate',
                'no user corresponding to the given email address');
            break;
          case 'ERROR_USER_DISABLED':
            showAlertDialog(
                context, 'Couldn\'t Authinticate', 'user has been disabled');
            break;
          case 'ERROR_TOO_MANY_REQUESTS':
            showAlertDialog(context, 'Couldn\'t Authinticate',
                'too many attempts to sign in as this user');
            break;
          case 'ERROR_OPERATION_NOT_ALLOWED':
            showAlertDialog(context, 'Couldn\'t Authinticate',
                'Email & Password accounts are not enabled');
            break;
        }
      }
      print(exception.toString());
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Creates an alertDialog for the user to enter their email
  Future<String> _resetDialogBox() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Reset email",
          auth: FirebaseAuth.instance,
        );
      },
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final FirebaseAuth auth;

  const CustomAlertDialog({Key key, this.title, this.auth}) : super(key: key);

  @override
  CustomAlertDialogState createState() {
    return new CustomAlertDialogState();
  }
}

class CustomAlertDialogState extends State<CustomAlertDialog> {
  final _resetKey = GlobalKey<FormState>();
  final _resetEmailController = TextEditingController();
  String _resetEmail;
  bool _resetValidate = false;

  StreamController<bool> rebuild = StreamController<bool>();

  bool _sendResetEmail() {
    _resetEmail = _resetEmailController.text;

    if (_resetKey.currentState.validate()) {
      _resetKey.currentState.save();

      try {
        // You could consider using async/await here
        widget.auth.sendPasswordResetEmail(email: _resetEmail);
        return true;
      } catch (exception) {
        print(exception);
      }
    } else {
      setState(() {
        _resetValidate = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        title: new Text(widget.title),
        content: new SingleChildScrollView(
          child: Form(
            key: _resetKey,
            autovalidate: _resetValidate,
            child: ListBody(
              children: <Widget>[
                new Text(
                  'Enter the Email Address associated with your account.',
                  style: TextStyle(fontSize: 14.0),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.email,
                        size: 20.0,
                        color: Color(Constants.COLOR_PRIMARY),
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        validator: validateEmail,
                        onSaved: (String val) {
                          _resetEmail = val;
                        },
                        controller: _resetEmailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            contentPadding:
                                EdgeInsets.only(left: 70.0, top: 15.0),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 14.0)),
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                new Column(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                width: 0.5, color: Colors.black))),
                  )
                ]),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              'CANCEL',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(
              'SEND EMAIL',
              style: TextStyle(color: Color(Constants.COLOR_PRIMARY)),
            ),
            onPressed: () {
              if (_sendResetEmail()) {
                Navigator.of(context).pop(_resetEmail);
              }
            },
          ),
        ],
      ),
    );
  }
}
