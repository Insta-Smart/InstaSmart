import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/home_screen.dart';

//This file has sample functions to
// upload user image to storage
// download the image from storage
// upload _imageFile Url to firestore
//download url from firestore and display

//import 'package:firebase_storage/firebase_storage.dart';

//https://www.youtube.com/watch?v=BUmewWXGvCA  --> reference link

class FramesScreenFunctions extends StatefulWidget {
  static const routeName = '/frames';
  @override
  _FramesScreenFunctionsState createState() => _FramesScreenFunctionsState();
}

class _FramesScreenFunctionsState extends State<FramesScreenFunctions> {
  File _imageFile; //image state variable
  bool _uploaded;
  // StorageReference _reference = FirebaseStorage.instance.ref("AllFrames").child("AllFrames").child("testImage.jpg");
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("AllFrames");
  final _firestore = Firestore.instance;
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

  Future uploadImage(String fileName) async {
    //add image to cloud storage
    StorageUploadTask uploadTask =
        _reference.child("${fileName}.jpg").putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      _uploaded = true;
    });
  }

//  Future downloadImage() async {
//    String downloadAddress =
//        await _reference.child("myImage.jpg").getDownloadURL();
//    setState(() {
//      _downloadurl = downloadAddress;
//    });
//  }

  Future setDownloadUrl(int index) async {
    //downloads image from storage, based on index [files named as sample_index
    // to directly display this image, use Image.network(_downloadurl)
    try {
      String downloadAddress =
          await _reference.child("sample_${index}.jpeg").getDownloadURL();
      print(downloadAddress);
      setState(() {
        _downloadurl = downloadAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  void uploadImagetoFirestore(int index) {
    setDownloadUrl(index);
    _firestore
        .collection('allframesurl')
        .add({'imageurl': _downloadurl, 'popularity': 0});
  }

  void getUrlFromFirestore() async {
    final allframesurl =
        await _firestore.collection('allframesurl').getDocuments();
    // allframesurl.documents --> returns a list of all items in firestore
    for (var el in allframesurl.documents) {
      print(el.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      uploadImage("test_uploadName");
                    },
                  ), //display image else nothing
            _uploaded == true
                ? RaisedButton(
                    child: Text("Download Image"),
                    onPressed: () {
                      setDownloadUrl(1);
                    })
                : Container(),
//            _downloadurl == null
//                ? Container()
//                : Expanded(child: Image.network(_downloadurl)),
            FlatButton(
              child: Text('Send Image URL to firestore'),
              onPressed: () {
                uploadImagetoFirestore(1);
              },
            ),
            FlatButton(
              child: Text("show all frames"),
              onPressed: () {
                for (int i = 0; i < 3; i++) {
                  setDownloadUrl(i);
                  // TODO: first, just try showing one image using the indexing method. WORKS
                  //TODO: implement a grid function that creates a grid
                  //TODO: put each image into the grid and display
                  //TODO: each user should have an image url attribute --> image that he picked to implement
                }
              },
            ),
            RaisedButton(
              child: Text("get image from firestore"),
              onPressed: () {
                getUrlFromFirestore();
              },
            )
          ],
        ),
      ),
    );
  }
}
