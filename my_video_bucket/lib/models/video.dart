import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_photo_bucket/models/firestore_model_utils.dart';

const String kVideoCollectionPath = "VideoBucket";
const String kVideo_authorUid = "authorUid";
const String kVideo_lastTouched = "lastTouched";
const String kVideo_caption = "caption";
const String kVideo_videoUrl = "videoUrl";

class Video {
  String? documentId;
  String authorUid;
  Timestamp lastTouched;
  String caption;
  String videoUrl;

  Video({
    this.documentId,
    required this.authorUid,
    required this.caption,
    required this.videoUrl,
    required this.lastTouched,
  });

  Video.from(DocumentSnapshot doc)
      : this(
    documentId: doc.id,
    authorUid:
    FirestoreModelUtils.getStringField(doc, kVideo_authorUid),
    lastTouched: FirestoreModelUtils.getTimestampField(
        doc, kVideo_lastTouched),
    caption: FirestoreModelUtils.getStringField(doc, kVideo_caption),
    videoUrl: FirestoreModelUtils.getStringField(doc, kVideo_videoUrl),
  );

  Map<String, Object?> toMap() {
    return {
      kVideo_authorUid: authorUid,
      kVideo_lastTouched: lastTouched,
      kVideo_caption: caption,
      kVideo_videoUrl: videoUrl,
    };
  }

  @override
  String toString() {
    return "$caption from the picture $videoUrl";
  }
}