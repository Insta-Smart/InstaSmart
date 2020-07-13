// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

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
          Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Expanded(),),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
