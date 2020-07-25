import 'dart:typed_data';
import 'package:instasmart/utils/overlayImages.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      'Take 2 images and overlay them:',
          () {
        test('returns the bytes of the overlyed image', () async {
          var imgBytes = await networkImageToByte(
              'https://drive.google.com/uc?export=view&id=19sjeFM_bR70UE37Lpa9FUgClOA71dLv4');
          var overlayed = overlayImages( imgBytes, imgBytes);
          expect(overlayed, isA<Uint8List>());
        });
      });
}
