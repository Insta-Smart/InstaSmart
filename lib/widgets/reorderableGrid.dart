import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:typed_data';

class ReorderableGrid extends StatefulWidget {
  final List<Asset> images;

  ReorderableGrid(this.images);

  @override
  _ReorderableGridState createState() => _ReorderableGridState();
}

class _ReorderableGridState extends State<ReorderableGrid> {
  final double _iconSize = 90;
  List<Asset> _tiles;

  @override
  void initState() {
    super.initState();
    _tiles = widget.images;
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Asset row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }

    var wrap = ReorderableWrap(
        spacing: 1.0,
        runSpacing: 1.0,
        padding: const EdgeInsets.all(0),
        children: List.generate(widget.images.length, (index) {
          var asset = widget.images[index].getByteData().then(
                (value) => Image.memory(
              value.buffer.asUint8List(),
//                  height: MediaQuery.of(context).size.width / 4, width: MediaQuery.of(context).size.width / 4
            ),
          );

          return FutureBuilder<Image>(
              future: asset,
              builder: (BuildContext context, AsyncSnapshot<Image> image) {
                return RaisedButton(
                  onPressed: ()=>print('press'),
                  padding: EdgeInsets.all(0),

                  child: Container(
                      height: (MediaQuery.of(context).size.width / 3.05),
                      width: (MediaQuery.of(context).size.width / 3.05),
                      child: FittedBox(child: image.data,fit: BoxFit.fill,)
                  ),
                );
//
              });

          //          return AssetThumb(
//            asset: asset,
//            width: (MediaQuery.of(context).size.width/3).round(),
//            height: (MediaQuery.of(context).size.width/3).round(),
//          );
        }
        ),
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
        });

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(child: wrap),
      ],
    );

    return column;
  }
}
