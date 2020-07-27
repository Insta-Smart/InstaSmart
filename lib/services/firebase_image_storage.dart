// Dart imports:

// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/services/login_functions.dart';

class FirebaseImageStorage {
  StorageReference reference = FirebaseStorage.instance.ref();
  FirebaseStorage instance = FirebaseStorage.instance;
  final db = Firestore.instance;
  final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();

  Future<void> mergeImageUrls(List imageUrls) async {
    //Merges the new image urls with currently existing image urls array on firestore
    try {
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .updateData({'user_images': FieldValue.arrayUnion(imageUrls)});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setImageUrls(List imageUrls) async {
    //Replaces the currently existing image urls on firestore with the input image urls
    try {
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .updateData({'user_images': imageUrls});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List> getImageUrls() async {
    //returns list of imageurls for current user
    try {
      var imageUrls;
      User user = await firebase.currentUser();
      print('current user in firebase_image_storage is: ${user.uid}');
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .get()
          .then((doc) => {imageUrls = doc['user_images']});
      return imageUrls == "" ? List() : imageUrls.reversed.toList();
    } catch (e) {
      print('error in getImageUrls is:');
      print(e.toString());
    }
  }

  Future<List> uploadAssetImage({@required List<Asset> assets}) async {
    List uploadUrls = List(assets.length);
    User user = await firebase.currentUser();

    await Future.wait(
        assets.map((Asset asset) async {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();

          StorageReference ref = reference.child("Preview_Images/${user.uid}/${DateTime.now()}");
          StorageUploadTask uploadTask = ref.putData(imageData);
          StorageTaskSnapshot storageTaskSnapshot;

          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          if (snapshot.error == null) {
            storageTaskSnapshot = snapshot;
            final String downloadUrl =
                await storageTaskSnapshot.ref.getDownloadURL();
            uploadUrls[assets.indexOf(asset)] = downloadUrl;

            print('Upload success');
          } else {
            print('Error from image repo ${snapshot.error.toString()}');
            throw ('This file is not an image');
          }
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });
    return uploadUrls;
  }

  Future<List> uploadByteImage({@required List<Uint8List> images}) async {
    List uploadUrls = List(images.length);
    User user = await firebase.currentUser();

    await Future.wait(
        images.map((Uint8List imageData) async {
          StorageReference ref =
              reference.child("Preview_Images/${user.uid}/${DateTime.now()}");
          print(ref);
          StorageUploadTask uploadTask = await ref.putData(imageData);
          print(uploadTask);
          StorageTaskSnapshot storageTaskSnapshot;

          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          if (snapshot.error == null) {
            storageTaskSnapshot = snapshot;
            final String downloadUrl =
                await storageTaskSnapshot.ref.getDownloadURL();
            uploadUrls[images.indexOf(imageData)] = downloadUrl;

            print('Upload success${images.indexOf(imageData)}');
          } else {
            print('Error from image repo ${snapshot.error.toString()}');
            throw ('This file is not an image');
          }
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });
    return uploadUrls;
  }

  Future<void> reorderImageArray(int oldIndex, int newIndex) async {
    // Reorders image urls array
    // Function is run when user reorders images on preview screen
    var imageUrls = await getImageUrls();
    List tempList = List();
    await imageUrls.forEach((element) {
      tempList.add(element);
    });
    var removed = tempList.removeAt(oldIndex);
    tempList.insert(newIndex, removed);
//    var temp = tempList[oldIndex];
//    tempList[oldIndex] = tempList[newIndex];
//    tempList[newIndex] = temp;
    await setImageUrls(tempList.reversed.toList());
  }

  Future<void> deleteImages(List imageUrls) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection(Constants.USERS)
          .document(user.uid)
          .updateData({'user_images': FieldValue.arrayRemove(imageUrls)});

      try {
        imageUrls.forEach((url) async {
          instance.getReferenceFromUrl(url).then((value) async {
            await value.delete();
          });
        });
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
