// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reorderables/reorderables.dart';

// Project imports:
import 'package:instasmart/constants.dart';
import 'package:instasmart/models/user.dart';
import 'package:instasmart/screens/preview_screen/components/bottom_sheet_options.dart';
import 'package:instasmart/screens/preview_screen/components/preview_photo.dart';
import 'package:instasmart/services/firebase_image_storage.dart';
import 'package:instasmart/services/login_functions.dart';
import 'package:instasmart/utils/size_config.dart';

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
                              height: SizeConfig.screenWidth / 3,
                              width: SizeConfig.screenWidth / 3,
                              child: FittedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            BottomSheetOptions(
                                              firebaseStorage: firebaseStorage,
                                              imageUrl: snapshot.data[index],
                                              screen: 'Preview',
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
