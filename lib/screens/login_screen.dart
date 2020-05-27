
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:instasmart/screens/home_screen.dart';
import '../constants.dart';
import '../models/login_functions.dart';
import 'package:provider/provider.dart';
import 'package:instasmart/models/user.dart';


class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';


  @override
  Widget build(BuildContext context) {
    final FirebaseFunctions firebase = FirebaseFunctions();
    Future<User> user = firebase.currentUser();

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
          if (!firebase.validateEmail(value)) {
            return "Please enter a valid email";
          }
          return null;
        },
        passwordValidator: (value) {
          if (!firebase.validatePassword(value)) {
            return "The password must be 8 characters or longer and should contain"
                "atleast 1 uppercase letter and 1 number";
          }
          return null;
        },
        onLogin: (LoginData){
          firebase.signInWithEmailAndPassword(LoginData.name, LoginData.password);
        },

        onSignup: (LoginData){
          firebase.createUserWithEmailAndPassword(LoginData.name, LoginData.password);
        },

        onSubmitAnimationCompleted: () {
          if (user != null) {
            Navigator.pushNamed(context, HomeScreen.routeName);
          } else {
            Navigator.pushNamed(context, LoginScreen.routeName);
          }
        },


        onRecoverPassword: (name) {
          firebase.sendPasswordResetEmail(name);
          return null;
          // Show new password dialog
        },
        showDebugButtons: false,
      ),
    );
  }
}
