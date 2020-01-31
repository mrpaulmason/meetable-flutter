import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetable/models/activity.dart';
import 'package:meetable/models/planDate.dart';
import 'package:meetable/models/user.dart';

import 'planTime.dart';

class Plan {
  final String uuid;
  final String createdBy;
  final String planInputText;
  final Timestamp creationDate;
  final bool isActive;
  final bool isDeleted;
  final List<User> users;
  final List<Activity> activities;
  final List<PlanDate> dates;
  final PlanTime time;
  final DocumentReference reference;

  Plan.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uuid'] != null),
        assert(map['createdBy'] != null),
        assert(map['planInputText'] != null),
        assert(map['creationDate'] != null),
        assert(map['isActive'] != null),
        assert(map['isDeleted'] != null),
        assert(map['users'] != null),
        assert(map['activities'] != null),
        assert(map['dates'] != null),
        assert(map['time'] != null),

        uuid = map['uuid'],
        createdBy = map['createdBy'],
        planInputText = map['planInputText'],
        creationDate = map['creationDate'],
        isActive = map['isActive'],
        isDeleted = map['isDeleted'],
        users = map['users'],
        activities = map['activities'],
        dates = map['dates'],
        time = map['time'];

  Plan.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Plan<$planInputText>";
}

Map<String, dynamic> createPlanMap() {
  var users = List();
  users.add(User.fromMap(createUserMap()));

  var map = new Map<String, dynamic>();
  map['uuid'] = "";
  map['createdBy'] = "";
  map['planInputText'] = "";
  map['creationDate'] = Timestamp.now();
  map['isActive'] = true;
  map['isDeleted'] = false;
  map['users'] = users;
  map['activities'] = null;
  map['dates'] = null;
  map['time'] = null;
  return map;
}