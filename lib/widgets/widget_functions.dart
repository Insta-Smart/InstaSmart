import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

Widget buildStaggeredView(images){
  return StaggeredGridView.countBuilder(
    crossAxisCount: 4 ,
    itemCount: images.length,
    itemBuilder: (BuildContext context, int index) {
      Asset asset = images[index];
      return ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: AssetThumb(
          asset: asset,
          width: 100,
          height: 300,
        ),
      );
    },
    staggeredTileBuilder: (int index) =>
    new StaggeredTile.count(2, index.isEven ? 2  : 1),
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
  );

}

Widget buildGridView(images) {
  return GridView.count(
    crossAxisCount: 3,
    children: List.generate(images.length, (index) {
      Asset asset = images[index];
      return AssetThumb(
        asset: asset,
        width: 100,
        height: 100,
      );
    }),
  );
}

