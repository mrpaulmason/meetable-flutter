import 'package:cloud_firestore/cloud_firestore.dart';

class PlanDate {
  final String uuid;
  final Timestamp date;
  final String status;
  final DocumentReference reference;

  PlanDate.fromMap(Map<String, dynamic> map, {this.reference})
      :
        uuid = map['uuid'],
        date = map['date'],
        status = map['status'];

  PlanDate.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "PlanDate<$date>";
}

Map<String, dynamic> createPlanDateMap(String uuid, Timestamp timestamp, {String status = "available"}) {
  var map = new Map<String, dynamic>();
  map['uuid'] = uuid;
  map['date'] = timestamp;
  map['status'] = status;
  return map;
}