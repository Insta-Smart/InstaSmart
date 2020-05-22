import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'home_screen.dart';
//import 'package:firebase_storage/firebase_storage.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

class FramesScreen extends StatefulWidget {
  static const routeName = '/frames';
  @override
  _FramesScreenState createState() => _FramesScreenState();
}

class _FramesScreenState extends State<FramesScreen> {
  File _imageFile; //image state variable
  bool _uploaded;

  // StorageReference _reference = FirebaseStorage.instance.ref("AllFrames").child("AllFrames").child("testImage.jpg");
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("AllFrames");
  String _downloadurl;
  //method to pick images from camera or gallery
  Future getImage(bool isCamera) async {
    //determine whether image from camera or gallery
    File image;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
      //returns an image file
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future uploadImage() async {
    StorageUploadTask uploadTask =
        _reference.child("new_image.jpg").putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
  }

  Future downloadImage() async {
    String downloadAddress =
        await _reference.child("myImage.jpg").getDownloadURL();
    setState(() {
      _downloadurl = downloadAddress;
    });
  }

  Future downloadAllImages(int index) async {
    try {
      String downloadAddress =
          await _reference.child("sample_${index}.jpeg").getDownloadURL();
      setState(() {
        _downloadurl = downloadAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("test changed branch"),
          FlatButton(
            child: Text('Camera'),
            onPressed: () {
              getImage(true);
            },
          ),
          SizedBox(height: 10),
          FlatButton(
            child: Text('Gallery'),
            onPressed: () {
              getImage(false);
            },
          ),
          _imageFile == null
              ? Container(color: Colors.blue)
              : Expanded(child: Image.file(_imageFile)),
          FlatButton(
            child: Text('Go to Home'),
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
          _imageFile == null
              ? Container()
              : RaisedButton(
                  child: Text('Upload to Storage'),
                  onPressed: () {
                    uploadImage();
                  },
                ), //display image else nothing
          _uploaded == true
              ? RaisedButton(
                  child: Text("Download Image"),
                  onPressed: () {
                    downloadImage();
                  })
              : Container(),
          _downloadurl == null
              ? Container()
              : Expanded(child: Image.network(_downloadurl)),
          FlatButton(
            child: Text("show all frames"),
            onPressed: () {
              for (int i = 0; i < 3; i++) {
                downloadAllImages(i);
                // TODO: first, just try showing one image using the indexing method.
                //TODO: implement a grid function that creates a grid
                //TODO: put each image into the grid and display
                //TODO: each user should have an image url attribute --> image that he picked to implement
              }
            },
          )
        ],
      ),
    );
  }
}
