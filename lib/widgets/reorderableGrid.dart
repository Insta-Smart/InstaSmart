import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reorderables/reorderables.dart';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instasmart/models/login_functions.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:instasmart/screens/reminder_create_form.dart';

//import 'package:popup_menu/popup_menu.dart';
//
class ReorderableGrid extends StatelessWidget {
  const ReorderableGrid({
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
                                  showBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                            color: Colors.transparent,
                                            height: 280,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                    leading: Icon(
                                                        Icons.calendar_today, ),
                                                    title: Text('Schedule Post'),
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
                                                ListTile(leading: Icon(Icons.delete),
                                                title: Text('Delete'),),
                                                ListTile(leading: Icon(Icons.style),
                                                  title: Text('Edit'),),
                                                ListTile(leading: Icon(Icons.share),
                                                  title: Text('Share'),),
                                                ListTile(leading: Icon(Icons.close),
                                                  title: Text('Close'),
                                                onTap: ()=>Navigator.pop(context),)
                                              ],
                                            ),
                                          ));
                                },
                                onDoubleTap: () {
                                  print('insert popup menu');
                                },
                                child: Hero(
                                  tag: snapshot.data[index],
                                  child: CachedNetworkImage(
                                    key: Key(snapshot.data[index]),
                                    imageUrl: snapshot.data[index],
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
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
        });
  }
}
