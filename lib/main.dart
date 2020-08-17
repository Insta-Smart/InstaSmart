// Dart imports:
import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instasmart/components/loading_screen.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/screens/calendar_screen/calendar_screen.dart';
import 'package:instasmart/screens/frames_screen/frames_screen.dart';
import 'package:instasmart/screens/liked_screen/liked_screen.dart';
import 'package:instasmart/screens/login_screen/login_screen.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_end_screen.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_screen.dart';
import 'package:instasmart/screens/preview_screen/preview_screen.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/login_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static User currentUser;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Constants.lightPurple));
    return AdaptiveTheme(
        light: ThemeData(
            colorScheme: ColorScheme.light(
              background: Colors.white,
              primary: Constants.lightPurple, //constant Color(0xFF16A5A6)
            ),
            primaryColor: Constants.lightPurple,
            accentColor: Constants.paleBlue,
            textSelectionColor: Constants.deepBlue,
            focusColor: Colors.black.withOpacity(0.4),
            backgroundColor: Colors.white,
            highlightColor: Colors.black54),
        dark: ThemeData(
            colorScheme: ColorScheme.dark(
                primary: Constants.lightPurple,
                primaryVariant: Constants.lightPurple),
            backgroundColor: Color(0xff444444),
            brightness: Brightness.dark,
            primaryColor: Constants.lightPurple,
            accentColor: Color(0xffc3fff6),
            focusColor: Colors.white,
            highlightColor: Colors.white24,
            textSelectionColor: Colors.white),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) =>
            ChangeNotifierProvider<FirebaseLoginFunctions>(
              create: (context) => FirebaseLoginFunctions(),
              child: MaterialApp(
                theme: theme,
                darkTheme: darkTheme,
                title: 'InstaSmart',
                debugShowCheckedModeBanner: false,
                home: FutureBuilder<User>(
                    future: FirebaseLoginFunctions().currentUser(),
                    builder:
                        (BuildContext context, AsyncSnapshot<User> snapshot) {
                      if (snapshot.hasData) {
                        MyAppState.currentUser = snapshot.data;
                        return HomeScreen();
                      }
                      if (!snapshot.hasData) {
                        return AuthScreen();
                      } else {
                        return LoadingScreen();
                      }
                    }),
                routes: {
                  LoginScreen.routeName: (context) => LoginScreen(),
                  HomeScreen.routeName: (context) => HomeScreen(),
                  FramesScreen.routeName: (context) => FramesScreen(),
                  PreviewScreen.routeName: (context) => PreviewScreen(),
                  CalendarScreen.routeName: (context) => CalendarScreen(),
                  LikedScreen.routeName: (context) => LikedScreen(),
                },
              ),
            ));
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser() != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        currentUser.active = false;
        currentUser.lastOnlineTimestamp = Timestamp.now();
        FirebaseLoginFunctions().updateUserData(currentUser.toJson());
      } else if (state == AppLifecycleState.resumed) {
        //user online
        currentUser.active = true;
        FirebaseLoginFunctions().updateUserData(currentUser.toJson());
      }
    }
  }
}

class OnBoarding extends StatefulWidget {
  @override
  State createState() {
    return OnBoardingState();
  }
}

class OnBoardingState extends State<OnBoarding> {
  Future hasFinishedOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool finishedOnBoarding =
        (prefs.getBool(Constants.FINISHED_ON_BOARDING) ?? false);

    if (finishedOnBoarding) {
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
      if (firebaseUser != null) {
        User user = await FirebaseLoginFunctions().currentUser();
        if (user != null) {
          MyAppState.currentUser = user;
          pushReplacement(context, new HomeScreen());
        } else {
          pushReplacement(context, new AuthScreen());
        }
      } else {
        pushReplacement(context, new AuthScreen());
      }
    } else {
      pushReplacement(context, new OnBoardingScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    hasFinishedOnBoarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Constants.COLOR_PRIMARY),
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
