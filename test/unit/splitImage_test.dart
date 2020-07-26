import 'dart:typed_data';
import 'package:instasmart/utils/splitImage.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
      'Split Image into parts based on given number of vertical and horizontal pieces:',
      () {
        var imgBytes;
    test('split into 3 parts (1x3) ', () async {
      imgBytes = await networkImageToByte(
          'https://drive.google.com/uc?export=view&id=19sjeFM_bR70UE37Lpa9FUgClOA71dLv4');
      var splitList = splitImage(
          imgBytes: imgBytes, verticalPieceCount: 3, horizontalPieceCount: 1);
      expect(splitList, isA<List<Uint8List>>());
      expect(splitList.length, 3);
    });
    test('split into 6 parts (2x3) ', () async {
      var splitList = splitImage(
          imgBytes: imgBytes, verticalPieceCount: 3, horizontalPieceCount: 2);
      expect(splitList, isA<List<Uint8List>>());
      expect(splitList.length, 6);
    });

    test('split into 9 parts (3x3)', () async {
      var splitList = splitImage(
          imgBytes: imgBytes, verticalPieceCount: 3, horizontalPieceCount: 3);
      expect(splitList, isA<List<Uint8List>>());
      expect(splitList.length, 9);
    });
  });
}
