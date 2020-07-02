import 'package:flutter/material.dart';
import 'package:instasmart/screens/create_grid_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GridFrame extends StatelessWidget {
  const GridFrame({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final CreateScreen widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView.customChild(
        backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        initialScale: 1.0,
        minScale: 1.0,
        maxScale: 5.0,
        child: Hero(
          tag: widget.index,
          child: CachedNetworkImage(
            imageUrl: widget.frameUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
