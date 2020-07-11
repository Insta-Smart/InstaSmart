// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:photo_view/photo_view.dart';

// Project imports:
import 'package:instasmart/screens/generate_grid/create_grid_screen.dart';
import 'package:instasmart/screens/reminder_screen/reminder_create_form.dart';
import 'package:instasmart/services/firebase_image_storage.dart';
import 'package:instasmart/utils/save_images.dart';
import 'package:instasmart/utils/size_config.dart';

class BottomSheetOptions extends StatelessWidget {
  const BottomSheetOptions({
    Key key,
    @required this.firebaseStorage,
    @required this.imageUrl,
  }) : super(key: key);

  final FirebaseImageStorage firebaseStorage;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.safeBlockVertical * 70,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth / 2,
            height: SizeConfig.screenWidth / 2,
            child: Hero(
              tag: imageUrl,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider: CachedNetworkImageProvider(
                  imageUrl,
                ),
                maxScale: 0.18,
                minScale: 0.18,
              ),
            ),
          ),
          ListTile(
              leading: Icon(
                Icons.calendar_today,
              ),
              title: Text('Schedule Post'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReminderForm(imageUrl),
                    ));
              }),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () async {
              Navigator.pop(context);
              await firebaseStorage.deleteImages([imageUrl]);
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('Save To Phone'),
            onTap: () async {
              var imgBytes = await networkImageToByte(imageUrl);
              saveImages([imgBytes]);
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CustomDialogWidget(
                        title: 'Saved!',
                        body: 'Images have been saved to gallery',
                      ));
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Close'),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
