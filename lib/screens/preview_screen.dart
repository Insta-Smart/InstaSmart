import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:reorderables/reorderables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:provider/provider.dart';
import 'reminder_create_form.dart';


class PreviewScreen extends StatefulWidget {
  static const routeName = '/preview';
  @override
  _PreviewScreenState createState() => new _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    super.initState();
  }

  var firebaseStorage = FirebaseImageStorage();

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "InstaSmart",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      await firebaseStorage
          .uploadImage(assets: resultList)
          .then((imageUrls) => firebaseStorage.mergeImageUrls(imageUrls));
    } on Exception catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var firebase = Provider.of<FirebaseFunctions>(context);

    return new MaterialApp(
      home: new Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('Users')
                      .document(firebase.currUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                     return  FutureBuilder<List>(
                          future: firebaseStorage.getImageUrls(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List> snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return ReorderableWrap(
                                minMainAxisCount: 3,
                                  spacing: 1.0,
                                  runSpacing: 1.0,
                                  padding: const EdgeInsets.all(0),
                                  children: List.generate(snapshot.data.length,
                                      (index) {
                                    return Container(
                                      height:
                                          (MediaQuery.of(context).size.width /
                                              3),
                                      width:
                                          (MediaQuery.of(context).size.width /
                                              3),
                                      child: FittedBox(
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ReminderForm(snapshot.data[index]),
                                              )
                                            );


                                          },
                                          child: Hero(
                                            tag: snapshot.data[index],
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data[index],
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  CircularProgressIndicator(
                                                      value: downloadProgress
                                                          .progress),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  }),
                                  onReorder: (int oldIndex, int newIndex) {
                                    firebaseStorage.reorderImageArray(oldIndex, newIndex);
                                  },
                                  onNoReorder: (int index) {
                                    //this callback is optional
                                    debugPrint(
                                        '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                                  },
                                  onReorderStarted: (int index) {
                                    //this callback is optional
                                    debugPrint(
                                        '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                                  });
                            }
                          });
                    }
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: loadAssets,
        ),
      ),
    );
  }
}
