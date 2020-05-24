import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:instasmart/screens/calendar_screen.dart';
import 'package:instasmart/screens/create_screen.dart';
import 'package:instasmart/screens/frames_screen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import 'package:instasmart/screens/overlaying_images_functions.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("InstaSmart")),
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
            Container(
              child: PreviewScreen(),
            ),
            Container(
              child: CalendarScreen(),
            ),
            Expanded(
              child: CreateScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        backgroundColor: Constants.lightPurple,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Search', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.search, color: Colors.white),
            activeColor: Constants.darkPurple,
          ),
          BottomNavyBarItem(
            title: Text('Preview', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.apps, color: Colors.white),
            activeColor: Constants.darkPurple,
          ),
          BottomNavyBarItem(
            title: Text('Reminders', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.access_time, color: Colors.white),
            activeColor: Constants.darkPurple,
          ),
          BottomNavyBarItem(
            title: Text('Create', style: TextStyle(color: Colors.white)),
            icon: Icon(
              Icons.create,
              color: Colors.white,
            ),
            activeColor: Constants.darkPurple,
          ),
        ],
      ),
    );
  }
}
