import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uuid;
  final String name;
  final String status; // joined, both
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uuid'] != null),
        assert(map['name'] != null),
        assert(map['status'] != null),

        uuid = map['uuid'],
        name = map['name'],
        status = map['status'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$name>";
}

Map<String, dynamic> createUserMap() {
  var map = new Map<String, dynamic>();
  map['uuid'] = "";
  map['name'] = "New User";
  map['status'] = "new";
  return map;
}