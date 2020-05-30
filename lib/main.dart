import 'package:flutter/material.dart';
import 'package:instasmart/screens/create_screen.dart';
import 'package:instasmart/screens/frames_screen.dart';
import 'package:instasmart/screens/home_screen.dart';
import 'package:instasmart/screens/login_screen.dart';
import 'package:instasmart/screens/overlaying_images_functions.dart';
import 'package:instasmart/screens/preview_screen.dart';
import 'package:instasmart/screens/calendar_screen.dart';
import 'package:instasmart/screens/reminder_modify_form.dart';
import 'package:provider/provider.dart';
import 'package:instasmart/models/login_functions.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirebaseFunctions>(
      create: (context)=> FirebaseFunctions(),
      child: MaterialApp(
        title: 'InstaSmart',
        theme: ThemeData(
          //      brightness: Brightness.light,
//        primarySwatch: Colors.indigo,
          primaryColor: Colors.white,
          backgroundColor: Colors.white,
          // fontFamily: 'SourceSansPro',
          textTheme: TextTheme(
            headline3: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 45.0,
              // fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            button: TextStyle(
              // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
              fontFamily: 'OpenSans',
            ),
            caption: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.deepPurple[300],
            ),
            headline1: TextStyle(fontFamily: 'Quicksand'),
            headline2: TextStyle(fontFamily: 'Quicksand'),
            headline4: TextStyle(fontFamily: 'Quicksand'),
            headline5: TextStyle(fontFamily: 'NotoSans'),
            headline6: TextStyle(fontFamily: 'NotoSans'),
            subtitle1: TextStyle(fontFamily: 'NotoSans'),
            bodyText1: TextStyle(fontFamily: 'NotoSans'),
            bodyText2: TextStyle(fontFamily: 'NotoSans'),
            subtitle2: TextStyle(fontFamily: 'NotoSans'),
            overline: TextStyle(fontFamily: 'NotoSans'),
          ),
        ),
        home: FutureBuilder<User>(
            future: FirebaseFunctions().currentUser(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {

              if(snapshot.hasData){
                Provider.of<FirebaseFunctions>(context).currUser = snapshot.data;
                return HomeScreen();
              }
              else{
                return LoginScreen();
              }
          }
        ),
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          FramesScreen.routeName: (context) => FramesScreen(),
          PreviewScreen.routeName: (context) => PreviewScreen(),
          CreateScreen.routeName: (context) => CreateScreen(),
          OverlayImagesFunctions.routeName: (context) => OverlayImagesFunctions(),
          CalendarScreen.routeName: (context) => CalendarScreen(),
        },
      ),
    );
  }
}
