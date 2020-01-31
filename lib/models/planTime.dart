import 'package:cloud_firestore/cloud_firestore.dart';

class PlanTime {
  final String timeType;
  final Timestamp startTime;
  final Timestamp endTime;
  //final Timestamp hardStop;
  final DocumentReference reference;

  PlanTime.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['timeType'] != null),
        assert(map['startTime'] != null),
        assert(map['endTime'] != null),

        timeType = map['timeType'],
        startTime = map['startTime'],
        endTime = map['endTime'];
        //hardStop = map['hardStop'];

  PlanTime.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "PlanTime<$startTime>";
}

Map<String, dynamic> createPlanTimeMap(Timestamp startTime, Timestamp endTime, /*String hardStop*/) {
  var map = new Map<String, dynamic>();
  map['timeType'] = "";
  map['startTime'] = startTime;
  map['endTime'] = endTime;
  //map['hardStop'] = hardStop;
  return map;
}