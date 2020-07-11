// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';

class PopupWidget extends StatelessWidget {
  const PopupWidget({
    Key key,
    @required this.imgUrl,
  }) : super(key: key);

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Color(0x88000000),
      child: Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
                color: Colors.white,
                child: CachedNetworkImage(imageUrl: imgUrl))),
      ),
    );
  }
}
