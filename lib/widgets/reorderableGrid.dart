import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instasmart/models/size_config.dart';
import 'package:instasmart/models/user.dart';
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

import '../constants.dart';

//import 'package:popup_menu/popup_menu.dart';
//
class ReorderableGrid extends StatelessWidget {
  const ReorderableGrid(
      {Key key,
      @required this.firebase,
      @required this.firebaseStorage,
      @required this.user})
      : super(key: key);

  final FirebaseLoginFunctions firebase;
  final FirebaseImageStorage firebaseStorage;
  final User user;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection(Constants.USERS)
            .document(user.uid)
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
                    return Container(
                      child: ReorderableWrap(
                          minMainAxisCount: 3,
                          spacing: 1.0,
                          runSpacing: 1.0,
                          padding: const EdgeInsets.all(0),
                          children:
                              List.generate(snapshot.data.length, (index) {
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
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 150,
                                                    child: Hero(
                                                      tag: snapshot.data[index],
                                                      child: PreviewPhoto(
                                                          snapshot.data[index]),
                                                    ),
                                                  ),
                                                  ListTile(
                                                      leading: Icon(
                                                        Icons.calendar_today,
                                                      ),
                                                      title:
                                                          Text('Schedule Post'),
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
                                                    title: Text('Delete'),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      await firebaseStorage
                                                          .deleteImages([
                                                        snapshot.data[index]
                                                      ]);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading:
                                                        Icon(Icons.save_alt),
                                                    title:
                                                        Text('Save To Phone'),
                                                    onTap: () async {
                                                      var imgBytes =
                                                          await networkImageToByte(
                                                              snapshot
                                                                  .data[index]);
                                                      saveImages([imgBytes]);
                                                      AwesomeDialog(
                                                        context: context,
                                                        headerAnimationLoop:
                                                            false,
                                                        dialogType:
                                                            DialogType.SUCCES,
                                                        animType: AnimType
                                                            .BOTTOMSLIDE,
                                                        title: 'Saved',
                                                        desc:
                                                            'Image have been saved to gallery',
                                                        btnOkOnPress: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )..show();
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
                            firebaseStorage.reorderImageArray(
                                oldIndex, newIndex);
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
                          }),
                    );
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
