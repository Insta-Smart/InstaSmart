import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
//import 'package:image_picker/image_picker.dart'; // For Image Picker
//import 'package:path/path.dart' as Path;
////https://www.c-sharpcorner.com/article/upload-image-file-to-firebase-storage-using-flutter/ ---> for file upload

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;
//  File _image;
//  String _uploadedFileURL;
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
      appBar: AppBar(title: Text("Frames")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
                child: new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) => new Container(
                  color: Colors.green,
                  child: new Center(
                    child: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: new Text('$index'),
                    ),
                  )),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )),
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
            title: Text('Home', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.home, color: Colors.white),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
            title: Text('Reminders', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.calendar_today, color: Colors.white),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
            title: Text('Frames', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.filter_frames, color: Colors.white),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
            title: Text('Preview', style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.apps, color: Colors.white),
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}
