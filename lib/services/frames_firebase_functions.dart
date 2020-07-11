// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:instasmart/categories.dart';
import 'package:instasmart/models/frame.dart';

class FramesFirebaseFunctions {

  final collectionRef = Firestore.instance.collection('Resized_Frames');

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
          if (el.data['imageurl'] == null || el.data['imageurl'] == "") {
            print("null url");
          } else {
            //  print('value of GetURLFromFirestore');
            //print(el.data['imageurl']);
            frameList.add(Frame(
                imgurl: el.data['imageurl'],
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
}
