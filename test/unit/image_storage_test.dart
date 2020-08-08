// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../mock_services/mock_firebase_image_storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Firebase Image Storage Functions:', () {
    List imageUrls = ['http://www.url1.jpg', 'http://www.url2.jpg'];
    List extraUrls = ['http://www.url3.jpg', 'http://www.url4.jpg'];
    String email = 'test@gmail.com';
    String password = '1234567Q';

    var imageStorage = MockFirebaseImageStorage();

    test('get list of image urls for the current user', () async {
      await imageStorage.firebase.signInWithEmailAndPassword(email, password);
      var urls = await imageStorage.getImageUrls();
      expect(urls, isA<Null>());
    });

    test(
        'replaces the currently existing image urls on firestore with the input image urls',
        () async {
      await imageStorage.setImageUrls(extraUrls);
      var urls = await imageStorage.getImageUrls();
      expect(urls.reversed, extraUrls);
      await imageStorage.setImageUrls(imageUrls);
      urls = await imageStorage.getImageUrls();
      expect(urls.reversed, imageUrls);
    });

    group('Merge image urls:', () {
      test('merging with same urls should not show any change ', () async {
        await imageStorage.mergeImageUrls(imageUrls);
        var urls = await imageStorage.getImageUrls();
        expect(urls.reversed, imageUrls);
      });

      test('merging with new urls should add on to the current list ',
          () async {
        await imageStorage.mergeImageUrls(extraUrls);
        var urls = await imageStorage.getImageUrls();
        expect(urls, isA<List>());
        expect(urls.length, 4);
      });
    });

    test('reorder image urls array by taking in given indices', () async {
      await imageStorage.reorderImageArray(1, 3);
      var urls = await imageStorage.getImageUrls();

      var expectedUrls = [
        'http://www.url3.jpg',
        'http://www.url1.jpg',
        'http://www.url2.jpg',
        'http://www.url4.jpg'
      ];

      expect(urls.reversed, expectedUrls);
    });

//    test('delete image urls', () async {
//      await imageStorage.deleteImages(extraUrls);
//      var urls = await imageStorage.getImageUrls();
//      expect(urls.reversed, imageUrls);
//    });

//    test('upload image to firebase storage', () async {
//      var imgBytes = await networkImageToByte('https://drive.google.com/uc?export=view&id=19sjeFM_bR70UE37Lpa9FUgClOA71dLv4');
//      var uploadUrls = await imageStorage.uploadByteImage(images: [imgBytes]);
//      expect(uploadUrls, isA<List>());
//      expect(uploadUrls.length, 1);
//    });
  });
}
