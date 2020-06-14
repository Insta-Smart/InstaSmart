import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reorderables/reorderables.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';
import 'package:instasmart/models/firebase_image_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:instasmart/models/login_functions.dart';

class ReorderableGrid extends StatefulWidget {
  final List<Asset> images;

  ReorderableGrid(this.images);

  @override
  _ReorderableGridState createState() => _ReorderableGridState();
}

class _ReorderableGridState extends State<ReorderableGrid> {
  final double _iconSize = 90;
  List<Asset> _tiles;
  var firebaseStorage = FirebaseImageStorage();


  @override
  void initState() {
    super.initState();
    _tiles = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    var firebase = Provider.of<FirebaseFunctions>(context);
    void _onReorder(int oldIndex, int newIndex) {
      print('reordered');
    }

//    var wrap = StreamBuilder<DocumentSnapshot>(stream: Firestore.instance
//        .collection('Users').document(firebase.currUser.uid).snapshots(),
//        builder: (context,snapshot){
//      if(!snapshot.hasData){
//        return Container();
//      }
//      else{
        var wrap= FutureBuilder<List>(
            future: firebaseStorage.getImageUrls(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return Expanded(
                  child: ReorderableWrap(
                      spacing: 1.0,
                      runSpacing: 1.0,
                      padding: const EdgeInsets.all(0),
                      children: List.generate(snapshot.data.length, (index) {
                        return Container(
                          height: (MediaQuery.of(context).size.width / 3.05),
                          width: (MediaQuery.of(context).size.width / 3.05),
                          child: FittedBox(
                            child: PhotoView(
//                              imageProvider: CachedNetworkImage(
//                                imageUrl: snapshot.data[index],
//                                progressIndicatorBuilder:
//                                    (context, url, downloadProgress) =>
//                                    CircularProgressIndicator(
//                                        value: downloadProgress.progress),
//                                errorWidget: (context, url, error) =>
//                                    Icon(Icons.error),
//                              ),
                            imageProvider: NetworkImage(snapshot.data[index]),

                            ),
                            fit: BoxFit.fill,
                          ),
                        );
                      }),
                      onReorder: _onReorder,
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

//      }
//
//        }
//
//    );



    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(child: wrap),
      ],
    );

    return wrap;
  }
}
