// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instasmart/utils/size_config.dart';

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
                width: SizeConfig.screenWidth * 0.7,
                color: Colors.white.withOpacity(0.5),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.fitWidth,
                ))),
      ),
    );
  }
}
