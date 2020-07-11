// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class GridFrame extends StatelessWidget {
  const GridFrame({
    Key key,
    @required this.index,
    @required this.frameUrl,
  }) : super(key: key);

  final String frameUrl;
  final int index;

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
          tag: index,
          child: Image.network(
            frameUrl,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
//          CachedNetworkImage (
//            imageUrl: widget.frameUrl,
//            progressIndicatorBuilder: (context, url, downloadProgress) =>
//                CircularProgressIndicator(value: downloadProgress.progress),
//            errorWidget: (context, url, error) => Icon(Icons.error),
//          ),
        ),
      ),
    );
  }
}
