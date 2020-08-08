// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../mock_services/mock_liking_functions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Liking Functions:', () {
    final email = 'test123@gmail.com';
    final password = '1234567Q';
    List frameUrls = [
      'http://www.url1.jpg',
      'http://www.url2.jpg',
      'http://www.url3.jpg',
      'http://www.url4.jpg'
    ];
    final likingFunctions = MockLikingFunctions();

    test('add frame_url to liked list once it is liked', () async {
      await likingFunctions.firebase
          .signInWithEmailAndPassword(email, password);
      likingFunctions.addImgToLiked('test1', frameUrls[0], frameUrls[1]);
      likingFunctions.addImgToLiked('test2', frameUrls[2], frameUrls[3]);
      var query = await likingFunctions.userRef
          .document(likingFunctions.user.uid)
          .collection('LikedFrames')
          .getDocuments();
      var data = query.documents.first.data;
      expect(query.documents.length, 2);
      expect(data.toString(),
          '{lowResUrl: http://www.url1.jpg, highResUrl: http://www.url2.jpg}');
    });

    test('delete frame_url from liked list', () async {
      likingFunctions.delImgFromLiked('test1');
      var query = await likingFunctions.userRef
          .document(likingFunctions.user.uid)
          .collection('LikedFrames')
          .getDocuments();
      var data = query.documents.first.data;
      expect(query.documents.length, 1);
      expect(data.toString(),
          '{lowResUrl: http://www.url3.jpg, highResUrl: http://www.url4.jpg}');
    });
    group('Update number of likes:', () {
      test('increment number of likes for a frame', () async {
        await likingFunctions.collectionRef
            .document(frameUrls[2])
            .setData({'popularity': 0});
        likingFunctions.updateLikes(frameUrls[2], true);
        var query = likingFunctions.collectionRef.document(frameUrls[2]);
        var snapshot = await query.get();
        expect(snapshot.data['popularity'], 1);
      });

      test('decrement number of likes for a frame', () async {
        await likingFunctions.collectionRef
            .document(frameUrls[2])
            .setData({'popularity': 2});
        likingFunctions.updateLikes(frameUrls[2], false);
        var query = likingFunctions.collectionRef.document(frameUrls[2]);
        var snapshot = await query.get();
        expect(snapshot.data['popularity'], 1);
      });
    });

    group('get liked status of a frame for a user', ()
    {
      test('return false if frame is not liked', () async {
        bool isLiked =  await likingFunctions.futInitLikedStat('test1');
        expect(isLiked, false);
      });

      test('return true if frame is liked', () async {
        bool isLiked =  await likingFunctions.futInitLikedStat('test2');
        expect(isLiked, true);
      });
    });

  });
}
