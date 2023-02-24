import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_photo_bucket/models/video.dart';

class VideoDocumentManager {
  Video? latestPhoto;
  final CollectionReference _ref;

  static final VideoDocumentManager instance =
  VideoDocumentManager._privateConstructor();

  VideoDocumentManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kVideoCollectionPath);

  StreamSubscription startListening(String documentId, Function() observer) {
    return _ref
        .doc(documentId)
        .snapshots()
        .listen((DocumentSnapshot docSnapshot) {
      latestPhoto = Video.from(docSnapshot);
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) =>
      subscription?.cancel();

  void update({
    required String caption,
    required String imageUrl,
  }) {
    if (latestPhoto == null) {
      return;
    }
    _ref.doc(latestPhoto!.documentId!).update({
      kVideo_caption: caption,
      kVideo_videoUrl: imageUrl,
      kVideo_lastTouched: Timestamp.now(),
    }).catchError((error) => print("Failed to update the photo: $error"));
  }

  Future<void> delete() {
    return _ref.doc(latestPhoto?.documentId!).delete();
  }
}