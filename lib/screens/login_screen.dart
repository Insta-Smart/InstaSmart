import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///C:/Users/noelm/Documents/InstaSmart/lib/screens/home_screen.dart';
import '../constants.dart';
import '../widgets/login_functions.dart';


class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  final _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterLogin(
        title: 'InstaSmart',
        logo: 'assets/images/instasmartLogo.png',
        theme: LoginTheme(
          buttonTheme: LoginButtonTheme(
            backgroundColor: Constants.brightPurple,
            elevation: 0,
          ),
        ),
        emailValidator: (value) {
          if (!validateEmail(value)) {
            return "Please enter a valid email";
          }
          return null;
        },
        passwordValidator: (value) {
          if (!validatePassword(value)) {
            return "The password must be 8 characters or longer and should contain"
                "atleast 1 uppercase letter and 1 number";
          }
          return null;
        },
        onLogin: (loginData) async {
          print('Login info');
          print('Name: ${loginData.name}');
          print('Password: ${loginData.password}');
          print(user);
          try {
            user = (await _auth.signInWithEmailAndPassword(
              email: loginData.name,
              password: loginData.password,
            ))
                .user;
          } catch (e) {
            print(e);
          }
          return null;
        },
        onSignup: (loginData) async {
          try {
            user = (await _auth.createUserWithEmailAndPassword(
              email: loginData.name,
              password: loginData.password,
            ))
                .user;
          } catch (e) {
            print(e);
          }

          return null;
        },
        onSubmitAnimationCompleted: () {
          if (user != null) {
            Navigator.pushNamed(context, HomeScreen.routeName);
          } else {
            Navigator.pushNamed(context, LoginScreen.routeName);
          }
        },
        onRecoverPassword: (name) {
          print('Recover password info');
          print('Name: $name');
          return null;
          // Show new password dialog
        },
        showDebugButtons: false,
      ),
    );
  }
}
