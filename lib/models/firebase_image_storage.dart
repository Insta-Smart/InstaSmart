import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:instasmart/models/login_functions.dart';
import 'dart:typed_data';
import 'package:instasmart/models/user.dart';

class FirebaseImageStorage {
  StorageReference _reference = FirebaseStorage.instance.ref();
  final db = Firestore.instance;
  final FirebaseLoginFunctions firebase = FirebaseLoginFunctions();

  Future<String> getDownloadUrl(int index) async {
    //downloads image from storage, based on index [files named as sample_index
    // to directly display this image, use Image.network(_downloadurl)
    try {
      String downloadAddress =
          await _reference.child("sample_${index}.jpeg").getDownloadURL();
      return downloadAddress;
    } catch (e) {
      print(e);
    }
  }

  Future<void> mergeImageUrls(List imageUrls) async {
    //Merges the new image urls with currently existing image urls array on firestore
    try {
      User user = await firebase.currentUser();
      await db
          .collection("Users")
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
          .collection("Users")
          .document(user.uid)
          .updateData({'user_images': imageUrls});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List> getImageUrls() async {
    //updates listofurls with imageurls
    try {
      List imageUrls;
      User user = await firebase.currentUser();
      await db
          .collection("Users")
          .document(user.uid)
          .get()
          .then((doc) => {imageUrls = doc['user_images']});
      return imageUrls.reversed.toList();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List> uploadAssetImage(
      {@required List<Asset> assets, @required String albumName}) async {
    List uploadUrls = List(assets.length);
    User user = await firebase.currentUser();

    await Future.wait(
        assets.map((Asset asset) async {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();

          StorageReference reference =
              _reference.child("Preview_Images/${user.uid}/${DateTime.now()}");
          StorageUploadTask uploadTask = reference.putData(imageData);
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
          StorageReference reference =
              _reference.child("Preview_Images/${user.uid}/${DateTime.now()}");
          StorageUploadTask uploadTask = reference.putData(imageData);
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
    var imageUrls = await getImageUrls();
    List tempList = List();
    imageUrls.forEach((element) {
      tempList.add(element);
    });
    var removed = tempList.removeAt(oldIndex);
    tempList.insert(newIndex, removed);
    await setImageUrls(tempList.reversed.toList());
  }

  Future<void> deleteImages(List imageUrls) async {
    try {
      User user = await firebase.currentUser();
      await db
          .collection("Users")
          .document(user.uid)
          .updateData({'user_images': FieldValue.arrayRemove(imageUrls)});
      var instance = FirebaseStorage.instance;
      imageUrls.forEach((url) async {
        instance.getReferenceFromUrl(url).then((value) async {
          await value.delete();
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
