import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itte/models/response.dart';

class DataRepository {
  final CollectionReference collection =
      Firestore.instance.collection('responses');
  final CollectionReference counters =
      Firestore.instance.collection('counters');

  Stream<QuerySnapshot> getStream() =>
      collection.where('comment', isGreaterThan: '').limit(50).snapshots();

  Future<DocumentSnapshot> counts() =>
      Firestore.instance.document('counters/counter').get();

  getMyResponse(id) =>
      collection.where('uniqueId', isEqualTo: id).limit(1).snapshots();

  Future<DocumentReference> addResponse(Response res) async {
    final DocumentReference ref = Firestore.instance.document('counters/counter');
    await Firestore.instance.runTransaction((Transaction tx) async {
      await collection.add(res.toJson());
      DocumentSnapshot sp = await tx.get(ref);
      await tx.update(ref, <String, dynamic>{
        'yes': (sp['yes'] as int) + (res.value ? 1 : 0),
        'no': (sp['no'] as int) + (res.value ? 0 : 1),
      });
    });
  }
}
