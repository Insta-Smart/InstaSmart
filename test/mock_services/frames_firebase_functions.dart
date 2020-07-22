// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:instasmart/categories.dart';
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/frame.dart';

class FramesFirebaseFunctions {
  final collectionRef =
      Firestore.instance.collection(Constants.ALL_FRAMES_COLLECTION);
  StorageReference _lowResReference =
      FirebaseStorage.instance.ref().child('FramesScreen');
  StorageReference _highResReference =
      FirebaseStorage.instance.ref().child('CreateScreen');
  String _downloadurl;
  List catList = Categories.catNamesList;

  //functions to refresh image store in firebase
  Future<String> setDownloadUrl(
      int index, String el, StorageReference refe) async {
    //downloads image from storage, based on index [files named as sample_index
    // to directly display this image, use Image.network(_downloadurl)
    try {
      String downloadAddress = await refe
          .child(el)
          .child("Untitled_Artwork ${index} copy-min.png")
          .getDownloadURL(); //image name
      //     print(downloadAddress);
      _downloadurl = downloadAddress;
      print('downloadurl is :');
      print(_downloadurl);
      return downloadAddress;
    } catch (e) {
      print("error in setDownloadUrl");
      print(e);
    }
  }

  //TODO: compress the frames better
  //TODO: put the uber compressed images into firebase and edit frame_widget to include 2 urls
  //TODO: run this function
  //TODO: remove white bkngd from create screen
  void uploadImagetoFirestore() async {
    try {
      for (String el in catList) {
        for (int i = 0; i < 23; i++) {
          String highResUrl;
          String lowResUrl;
          await setDownloadUrl(i, el, _lowResReference).then((value) {
            lowResUrl = value;
            print('initial lowres ${lowResUrl}');
          });
          await setDownloadUrl(i, el, _highResReference).then((value) {
            print('final lowres is ${lowResUrl}');
            highResUrl = value;
            if (lowResUrl == null) {
            } else {
              collectionRef.document(lowResUrl.substring(75)).setData({
                'lowResUrl': lowResUrl,
                'highResUrl': highResUrl,
                'popularity': 1,
                'category': el
              });
            }
            print("sent");
          });
        }
      }
    } catch (e) {
      print('error in uploading image url');
      print(e);
    }
    //print("new_downloadurl is ${_downloadurl}");
  }

  Future<List<Frame>> GetUrlAndIdFromFirestore(String category) async {
    print('calling get url');

    List<Frame> frameList = new List<Frame>();
    var doc;
    try {
      if (category == Categories.all) {
        doc = await collectionRef.orderBy("popularity", descending: true);
      } else {
        doc = await collectionRef
            .orderBy("popularity", descending: true)
            .where('category', isEqualTo: category);
      }
      await doc.getDocuments().then((value) {
        value.documents.forEach((el) {
          if (el.data['lowResUrl'] == null || el.data['lowResUrl'] == "") {
            print("null url");
          } else {
            //  print('value of GetURLFromFirestore');
            //print(el.data['imageurl']);
            frameList.add(Frame(
                lowResUrl: el.data['lowResUrl'],
                highResUrl: el.data['highResUrl'],
                imgID: el.documentID,
                category: el.data[
                    'category'])); //some frames dont have a category field
          }
          //create a map
          //  });
        });
      });
      return frameList;
    } catch (e) {
      print('error in gettingurl:${e}');
    }
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

  List<Frame> filterFrames(String category, List<Frame> origList) {
    List<Frame> filteredFrameList = new List<Frame>();
    if (category == Categories.all) {
      filteredFrameList = origList;
    } else {
      for (Frame el in origList) {
        if (el.category == category) {
          filteredFrameList.add(el);
//          print('filterframe printing');
//          print(el.category);
        }
      }
    }
    //  print('outcome of filterframes: ${filteredFrameList}');
    return filteredFrameList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
