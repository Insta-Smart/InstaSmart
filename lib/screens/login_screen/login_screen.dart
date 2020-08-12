// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/main.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/test_driver/Keys.dart';
import 'package:instasmart/utils/helper.dart';
import '../HomeScreen.dart';

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
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
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
                        color: Theme.of(context).primaryColor,
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
                      key: Key(Keys.enterEmail),
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
                      cursorColor: Theme.of(context).focusColor,
                      decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.only(left: 16, right: 16),
                          fillColor: Colors.white,
                          hintText: 'Enter your Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
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
                      key: Key(Keys.enterPassword),
                      textAlignVertical: TextAlignVertical.center,
                      validator: validatePassword,
                      onSaved: (String val) {
                        password = val.trim().replaceAll(' ', '');
                      },
                      onFieldSubmitted: (password) async {
                        await onClick(
                            _emailController.text, _passwordController.text);
                      },
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18.0),
                      obscureText: true,
                      cursorColor: Theme.of(context).focusColor,
                      decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.only(left: 16, right: 16),
                          fillColor: Colors.white,
                          hintText: 'Enter your Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
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
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Log In',
                      key: Key(Keys.secondLogin),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    textColor: Colors.white,
                    splashColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      await onClick(
                          _emailController.text, _passwordController.text);
                    },
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'OR',
                    style: TextStyle(color: Theme.of(context).primaryColor),
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
                    textColor: Theme.of(context).primaryColor,
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
      MyAppState.currentUser = user;
      if (user != null) pushAndRemoveUntil(context, HomeScreen(), false);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  Future<User> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      User user = await FirebaseLoginFunctions()
          .signInWithEmailAndPassword(email, password);

      var documentSnapshot = await FirebaseLoginFunctions()
          .db
          .collection(Constants.USERS)
          .document(user.uid)
          .get();
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data);
        user.active = true;
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
            showAlertDialog(context, 'Couldn\'t Authenticate',
                'email address is malformed');
            break;
          case 'ERROR_WRONG_PASSWORD':
            showAlertDialog(context, 'Incorrect Password', 'Please try again');
            break;
          case 'ERROR_USER_NOT_FOUND':
            showAlertDialog(context, 'Account not found',
                'No account with was found with the entered email address');
            break;
          case 'ERROR_USER_DISABLED':
            showAlertDialog(
                context, 'Couldn\'t Authenticate', 'user has been disabled');
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
          title: "Reset Password",
        );
      },
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  final String title;

  const CustomAlertDialog({Key key, this.title}) : super(key: key);

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
        FirebaseLoginFunctions().sendPasswordResetEmail(_resetEmail);
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
                  'Enter the email associated with your account.',
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
                        color: Theme.of(context).primaryColor,
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
                            hintText: 'Enter your Email',
                            contentPadding:
                                EdgeInsets.only(left: 10.0, top: 10),
                            hintStyle: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 14.0)),
                        style: TextStyle(color: Theme.of(context).focusColor),
                      ),
                    )
                  ],
                ),
                new Column(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                width: 0.5,
                                color: Theme.of(context).focusColor))),
                  )
                ]),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text(
              'Send Reset Email',
              style: TextStyle(color: Theme.of(context).primaryColor),
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
