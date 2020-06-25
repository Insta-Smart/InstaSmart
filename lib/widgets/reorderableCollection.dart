import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/screens/final_grid_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reorderables/reorderables.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instasmart/screens/reminder_create_form.dart';
import 'package:instasmart/models/save_images.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:flutter/cupertino.dart';

//import 'package:popup_menu/popup_menu.dart';
//
class ReorderableCollection extends StatelessWidget {
  const ReorderableCollection({
    Key key,
    @required this.firebase,
    @required this.firebaseStorage,
  }) : super(key: key);

  final FirebaseFunctions firebase;
  final FirebaseImageStorage firebaseStorage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('Users')
            .document(firebase.currUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return FutureBuilder<List>(
                future: firebaseStorage.getImageUrls(),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return ReorderableWrap(
                        minMainAxisCount: 3,
                        spacing: 1.0,
                        runSpacing: 1.0,
                        padding: const EdgeInsets.all(0),
                        children: List.generate(snapshot.data.length, (index) {
                          return Container(
                            height: (MediaQuery.of(context).size.width / 3),
                            width: (MediaQuery.of(context).size.width / 3),
                            child: FittedBox(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                            color: Colors.transparent,
                                            height: 280,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                    leading: Icon(
                                                      Icons.calendar_today,
                                                    ),
                                                    title: Text(
                                                        'Add to Preview screen *even if its all there'),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ReminderForm(
                                                                    snapshot.data[
                                                                        index]),
                                                          ));
                                                    }),
                                                ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text(
                                                      'Delete *but not from preview'),
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await firebaseStorage
                                                        .deleteImages([
                                                      snapshot.data[index]
                                                    ]);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.save_alt),
                                                  title: Text(
                                                      'Save - download all 3/6/9 images to users phone'),
                                                  onTap: () async {
                                                    var imgBytes =
                                                        await networkImageToByte(
                                                            snapshot
                                                                .data[index]);
                                                    saveImages([imgBytes]);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.close),
                                                  title: Text('Close'),
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                )
                                              ],
                                            ),
                                          ));
                                },
                                onDoubleTap: () {
                                  CupertinoContextMenu();
                                },
                                child: Hero(
                                  tag: snapshot.data[index],
                                  child: PreviewPhoto(snapshot.data[index]),
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
        });
  }
}

class PreviewPhoto extends StatefulWidget {
  var imgUrl;
  PreviewPhoto(this.imgUrl);
  @override
  _PreviewPhotoState createState() => _PreviewPhotoState();
}

class _PreviewPhotoState extends State<PreviewPhoto> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: Key(widget.imgUrl),
      imageUrl: widget.imgUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
