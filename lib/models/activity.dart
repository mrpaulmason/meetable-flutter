import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String uuid;
  final String graphic;
  final String type;
  final String description;
  final DocumentReference reference;

  Activity.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uuid'] != null),
        assert(map['graphic'] != null),
        assert(map['type'] != null),
        assert(map['description'] != null),

        uuid = map['uuid'],
        graphic = map['graphic'],
        type = map['type'],
        description = map['description'];

  Activity.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Activity<$description>";
}

//Map<String, dynamic> createActivityMap() {
//  var map = new Map<String, dynamic>();
//  map['uuid'] = "";
//  map['graphic'] = "";
//  map['type'] = "";
//  map['description'] = "";
//  return map;
//}