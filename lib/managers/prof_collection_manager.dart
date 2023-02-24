import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:my_photo_bucket/managers/auth_manager.dart';
import 'package:final_proj_dart/models/prof.dart';

class ProfCollectionManager {
  List<Prof> latestProfs = [];
  final CollectionReference _ref;

  static final ProfCollectionManager instance =
  ProfCollectionManager._privateConstructor();

  ProfCollectionManager._privateConstructor()
      : _ref = FirebaseFirestore.instance.collection(kProfCollectionPath);

  StreamSubscription startListening(Function() observer,
      {bool isFilteredForMine = false}) {
    Query query = _ref.orderBy(kProf_lastTouched, descending: true);
    // if (isFilteredForMine) {
    //   query = query.where(kProf_authorUid,
    //       isEqualTo: AuthManager.instance.uid);
    // }
    return query.snapshots().listen((QuerySnapshot querySnapshot) {
      latestProfs =
          querySnapshot.docs.map((doc) => Prof.from(doc)).toList();
      observer();
    });
  }

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> add({
    required String name,
    required String office,
  }) {
    return _ref
        .add({
      // kProf_authorUid: AuthManager.instance.uid,
      kProf_name: name,
      kProf_office: office,
      kProf_lastTouched: Timestamp.now(),
    })
        .then((DocumentReference docRef) =>
        print("Photo added with id ${docRef.id}"))
        .catchError((error) => print("Failed to add Photo: $error"));
  }

  // Firebase UI Firestore stuff

  Query<Prof> get allPhotosQuery => _ref
      .orderBy(kProf_lastTouched, descending: true)
      .withConverter<Prof>(
    fromFirestore: (snapshot, _) => Prof.from(snapshot),
    toFirestore: (p, _) => p.toMap(),
  );
  //
  // Query<Prof> get mineOnlyPhotosQuery => allPhotosQuery
  //     .where(kPhoto_authorUid, isEqualTo: AuthManager.instance.uid);
}