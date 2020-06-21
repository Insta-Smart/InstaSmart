import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/frame.dart';
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
  final _firestore = Firestore.instance;
  String _downloadurl;
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("FramesPNG");
  final collectionRef = Firestore.instance.collection('allframespngurl');

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

  Future<List<Frame>> getUrlAndIdFromFirestore(String val) async {
    //updates LinkdHashMap with imageurls
    List<Frame> frameList = new List<Frame>();
    await collectionRef
        .orderBy("popularity", descending: true)
        .where('category', isEqualTo: val)
        .getDocuments()
        .then((value) {
      value.documents.forEach((el) {
        print(el.data);
        setState(() {
          if (el.data['imageurl'] == null || el.data['imageurl'] == "") {
            print("null url");
          } else {
            //    print(el.data['imageurl']);
            frameList
                .add(Frame(imgurl: el.data['imageurl'], imgID: el.documentID));
          }
          //create a map
        });
      });
    });
    return frameList;
  }

  //RETURNS IMGID IN ALLFRAMESPNGURL BY USING IMGURL
  //CREATES A FRAME MODEL ALSO
  //TODO:DONT DELETE THIS
  Future<String> getFrameID(String imgurl) async {
    String imgID;
    var result =
        await collectionRef.where("imageurl", isEqualTo: imgurl).getDocuments();
    result.documents.forEach((res) {
      imgID = res.documentID;
    });
    print('imgID is ${imgID}');
    // frame = Frame(imgurl: widget.imgurl, imgID: imgID);
    return imgID;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
