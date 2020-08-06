//Flutter imports:
import 'package:flutter/material.dart';

//Package imports:
import 'package:shimmer/shimmer.dart';

//Project imports:
import 'package:instasmart/utils/size_config.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            // margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
            height: SizeConfig.blockSizeVertical * 23,
            width: SizeConfig.screenWidth * 0.40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(2, 3), // changes position of shadow
                ),
              ],
            ),
// L-R margin should be same as GridView container margin in frames_screen.dart
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: SizeConfig.screenWidth * 0.5,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      child: Container(
                        height: SizeConfig.screenWidth / 2,
                        width: SizeConfig.screenWidth / 2,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )),
          ),
          Expanded(
            child: Container(
              //alignment: Alignment.center,
              color: Colors.white.withOpacity(0.3),
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 0),
            ),
            //  alignment: Alignment(0, 0.8),
          ),
        ],
      ),
    );
  }
}
