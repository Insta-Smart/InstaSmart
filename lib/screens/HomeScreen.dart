import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/custom_packages/bottom_navy_bar_custom/bottom_navy_bar_custom.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/AuthScreen.dart';
import 'package:instasmart/screens/preview_screen.dart';
import 'package:instasmart/services/Authenticate.dart';
import 'package:instasmart/utils/helper.dart';

import 'package:instasmart/main.dart';

import 'account_screen.dart';
import 'calendar_screen.dart';
import 'frames_screen.dart';
import 'liked_screen.dart';

FireStoreUtils _fireStoreUtils = FireStoreUtils();

class HomeScreen extends StatefulWidget {
  final User user;
  static const routeName = '/home';
  final int index;

  HomeScreen({Key key, @required this.user, this.index}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<HomeScreen> {
  final User user;

  _HomeState(this.user);
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
              child: PreviewScreen(user: user),
            ),
            Container(
              child: CalendarScreen(user: user),
            ),
            Expanded(
              child: AccountScreen(user: user),
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
