import 'package:flutter/material.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/constants.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 70.0, bottom: 20.0),
                child: Icon(
                  Icons.phone_iphone,
                  size: 150,
                  color: Color(Constants.COLOR_PRIMARY),
                ),
              ),
            ),
            Text(
              'Say Hello To Your New App!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(Constants.COLOR_PRIMARY),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You\'ve just saved a week of development and headaches.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  color: Color(Constants.COLOR_PRIMARY),
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  splashColor: Color(Constants.COLOR_PRIMARY),
                  onPressed: () {
                    push(context, new LoginScreen());
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Color(Constants.COLOR_PRIMARY))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: FlatButton(
                  textColor: Colors.black54,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    push(context, new SignUpScreen());
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.black54)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
