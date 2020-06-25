import 'package:flutter/material.dart';
//import 'package:flutter_login/flutter_login.dart';
import 'package:instasmart/custom_packages/flutter_login_custom/flutter_login.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/screens/home_screen.dart';
import '../constants.dart';
import '../models/login_functions.dart';
import 'package:provider/provider.dart';
import 'package:instasmart/models/user.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final FirebaseFunctions firebase = Provider.of<FirebaseFunctions>(context);
    Future<User> user = firebase.currentUser();

    return SafeArea(
      child: FlutterLogin(
        title: 'Beautify your feed. Effortlessly.',
        // logo: 'assets/images/instasmartLogo.png',
        messages: LoginMessages(loginButton: "Login", signupButton: "Sign Up"),
        theme: LoginTheme(
            titleStyle: TextStyle(
                fontSize: 28,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500),
            bodyStyle: TextStyle(color: Colors.black, fontSize: 15),
            buttonStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            textFieldStyle: TextStyle(fontSize: 20),
            inputTheme: InputDecorationTheme(
              errorStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            errorColor: Color(0xFFf4C05C90),
            accentColor: Constants.paleBlue,
            buttonTheme: LoginButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardTheme(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
            )),
        emailValidator: (value) {
          if (!firebase.validateEmail(value)) {
            return "Please enter a valid email";
          }
          return null;
        },
        passwordValidator: (value) {
          if (!firebase.validatePassword(value)) {
            return "Password must have at least:\n • 8 characters\n • 1 uppercase letter\n • 1 number";
          }
          return null;
        },
        onLogin: (LoginData) {
          firebase.signInWithEmailAndPassword(
              LoginData.name, LoginData.password);
        },
        onSignup: (LoginData) {
          firebase.createUserWithEmailAndPassword(
              LoginData.name, LoginData.password);
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
