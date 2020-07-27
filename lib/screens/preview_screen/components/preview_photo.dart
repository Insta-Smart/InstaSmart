// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// Project imports:
import 'package:instasmart/utils/size_config.dart';

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
    SizeConfig().init(context);
    return CachedNetworkImage(
      key: Key(widget.imgUrl),
      imageUrl: widget.imgUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          height: SizeConfig.screenWidth / 3,
          width: SizeConfig.screenWidth / 3,
          color: Colors.grey,
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
