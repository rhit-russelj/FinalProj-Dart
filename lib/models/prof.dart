import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj_dart/models/firestore_model_utils.dart';

const String kProfCollectionPath = "FinalProj";
const String kProf_authorUid = "authorUid";
const String kProf_lastTouched = "lastTouched";
const String kProf_name = "name";
const String kProf_office = "office";

class Prof {
  String? documentId;
  String authorUid;
  Timestamp lastTouched;
  String name;
  String office;

  Prof({
    this.documentId,
    required this.authorUid,
    required this.name,
    required this.office,
    required this.lastTouched,
  });

  Prof.from(DocumentSnapshot doc)
      : this(
    documentId: doc.id,
    authorUid:
    FirestoreModelUtils.getStringField(doc, kProf_authorUid),
    lastTouched: FirestoreModelUtils.getTimestampField(
        doc, kProf_lastTouched),
    name: FirestoreModelUtils.getStringField(doc, kProf_name),
    office: FirestoreModelUtils.getStringField(doc, kProf_office),
  );

  Map<String, Object?> toMap() {
    return {
      kProf_authorUid: authorUid,
      kProf_lastTouched: lastTouched,
      kProf_name: name,
      kProf_office: office,
    };
  }

  @override
  String toString() {
    return "$name from the picture $office";
  }
}