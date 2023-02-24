import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_photo_bucket/managers/auth_manager.dart';
import 'package:my_photo_bucket/models/video.dart';

class VideoBucketCollectionManager {
  List<Video> latestPhotos = [];
  final CollectionReference _ref;

  static final VideoBucketCollectionManager instance =
  VideoBucketCollectionManager._privateConstructor();

  VideoBucketCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kVideoCollectionPath);

  StreamSubscription startListening(Function() observer,
      {bool isFilteredForMine = false}) {
    Query query = _ref.orderBy(kVideo_lastTouched, descending: true);
    if (isFilteredForMine) {
      query = query.where(kVideo_authorUid,
          isEqualTo: AuthManager.instance.uid);
    }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      latestPhotos =
          querySnapshot.docs.map((doc) => Video.from(doc)).toList();
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> add({
    required String caption,
    required String imageUrl,
  }) {
    return _ref
        .add({
      kVideo_authorUid: AuthManager.instance.uid,
      kVideo_caption: caption,
      kVideo_videoUrl: imageUrl,
      kVideo_lastTouched: Timestamp.now(),
    })
        .then((DocumentReference docRef) =>
        print("Photo added with id ${docRef.id}"))
        .catchError((error) => print("Failed to add Video: $error"));
  }

  // Firebase UI Firestore stuff

  Query<Video> get allPhotosQuery => _ref
      .orderBy(kVideo_lastTouched, descending: true)
      .withConverter<Video>(
    fromFirestore: (snapshot, _) => Video.from(snapshot),
    toFirestore: (p, _) => p.toMap(),
  );

  Query<Video> get mineOnlyPhotosQuery => allPhotosQuery
      .where(kVideo_authorUid, isEqualTo: AuthManager.instance.uid);
}