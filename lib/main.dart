// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instasmart/components/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:instasmart/screens/calendar_screen/calendar_screen.dart';
import 'package:instasmart/screens/liked_screen/liked_screen.dart';
import 'package:instasmart/screens/login_screen/login_screen.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_end_screen.dart';
import 'package:instasmart/screens/onboarding_screen/onboarding_screen.dart';
import 'package:instasmart/screens/preview_screen/preview_screen.dart';
import 'services/login_functions.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/screens/HomeScreen.dart';
import 'package:instasmart/screens/frames_screen/frames_screen.dart';
import 'package:instasmart/services/Authenticate.dart';
import 'package:instasmart/utils/helper.dart';
import 'package:instasmart/models/user.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static User currentUser;

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(
//        SystemUiOverlayStyle(statusBarColor: Constants.lightPurple));
    return ChangeNotifierProvider<FirebaseLoginFunctions>(
      create: (context) => FirebaseLoginFunctions(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Constants.lightPurple,
            accentColor: Constants.paleBlue,
            backgroundColor: Colors.white),
        title: 'InstaSmart',
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<User>(
            future: FirebaseLoginFunctions().currentUser(),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if (snapshot.hasData) {
                return HomeScreen(user: snapshot.data);
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
    );
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
