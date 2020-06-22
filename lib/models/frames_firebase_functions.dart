import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/categories.dart';
import 'package:instasmart/models/frame.dart';

class FramesFirebaseFunctions {
//    extends StatefulWidget {
//  var framesFirebaseFns = new _FramesFirebaseFunctionsState();
//
//  @override
//  _FramesFirebaseFunctionsState createState() =>
//      _FramesFirebaseFunctionsState();
////  Future<List<Frame>> getUrlAndIdFromFirestore(String val) async {
////    framesFirebaseFns.getUrlAndIdFromFirestore(val);
////  }
////
////  Future<String> getFrameID(String imgurl) async {
////    framesFirebaseFns.getFrameID(imgurl);
////  }
//}
//
//class _FramesFirebaseFunctionsState extends State<FramesFirebaseFunctions> {
  StorageReference _reference =
      FirebaseStorage.instance.ref().child("FramesPNG");
  final collectionRef = Firestore.instance.collection('allframespngurl');

  Future<List<Frame>> GetUrlAndIdFromFirestore(String val) async {
    //updates LinkdHashMap with imageurls
    List<Frame> frameList = new List<Frame>();
    var doc;
    if (val == Categories.all) {
      doc = await collectionRef.orderBy("popularity", descending: true);
    } else {
      doc = await collectionRef
          .orderBy("popularity", descending: true)
          .where('category', isEqualTo: val);
    }
    doc.getDocuments().then((value) {
      value.documents.forEach((el) {
        print(el.data);
        //  setState(() {
        if (el.data['imageurl'] == null || el.data['imageurl'] == "") {
          print("null url");
        } else {
          //    print(el.data['imageurl']);
          frameList.add(Frame(
              imgurl: el.data['imageurl'],
              imgID: el.documentID,
              category: el.data['category']));
        }
        //create a map
        //  });
      });
    });
    print("framelist is ${frameList}");
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
    return imgID;
  }

  List<Frame> filterFrames(String cat, List<Frame> origList) {
    List<Frame> filteredFrameList = new List<Frame>();
    if (cat == Categories.all) {
      filteredFrameList = origList;
    } else {
      for (Frame el in origList) {
        if (el.category == cat) {
          filteredFrameList.add(el);
//          print('filterframe printing');
//          print(el.category);
        }
      }
    }
    //  print('outcome of filterframes: ${filteredFrameList}');
    return filteredFrameList;
  }
}
