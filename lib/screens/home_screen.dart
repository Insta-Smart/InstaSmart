import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:instasmart/custom_packages/bottom_navy_bar_custom/bottom_navy_bar_custom.dart';
import 'package:instasmart/screens/calendar_screen.dart';
import 'package:instasmart/screens/create_grid_screen.dart';
import 'package:instasmart/screens/frames_screen.dart';
import 'package:instasmart/screens/liked_screen.dart';
import 'package:instasmart/screens/login_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import '../constants.dart';
import 'package:provider/provider.dart';
import 'package:instasmart/models/login_functions.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final int index;

  HomeScreen({Key key, this.index}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index == null ? 0 : widget.index;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("InstaSmart"),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.exit_to_app),
//              onPressed: () {
//                FirebaseFunctions().signOut().then((value) =>
//                    Navigator.pushNamed(context, LoginScreen.routeName));
//              })
//        ],
//      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: FramesScreen(),
            ),
            Expanded(
              child: LikedScreen(),
            ),
            Container(
              child: PreviewScreen(),
            ),
            Container(
              child: CalendarScreen(),
            ),
            Expanded(
              child: LoginScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBarCustom(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        backgroundColor: Colors.white,
        items: <BottomNavyBarCustomItem>[
          BottomNavyBarCustomItem(
            title: Text('Explore'),
            icon: Icon(Icons.search),
            activeColor: Constants.lightPurple,
          ),
          BottomNavyBarCustomItem(
            title: Text('Liked'),
            icon: Icon(
              Icons.favorite_border,
            ),
            activeColor: Constants.lightPurple,
          ),
          BottomNavyBarCustomItem(
            title: Text('My Grids'),
            icon: Icon(Icons.apps),
            activeColor: Constants.lightPurple,
          ),
          BottomNavyBarCustomItem(
            title: Text(
              'Calender',
              style: TextStyle(fontSize: 14, letterSpacing: 0.5),
            ),
            icon: Icon(Icons.access_time),
            activeColor: Constants.lightPurple,
          ),
          BottomNavyBarCustomItem(
            title: Text('Profile'),
            icon: Icon(
              Icons.account_circle,
            ),
            activeColor: Constants.lightPurple,
          ),
        ],
      ),
    );
  }
}
