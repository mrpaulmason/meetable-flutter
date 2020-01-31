import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetable/models/activity.dart';
import 'package:meetable/models/plan.dart';
import 'package:meetable/models/user.dart';
import 'package:meetable/ui/plan/dates.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  ActivitiesScreenState createState() {
    return new ActivitiesScreenState();
  }
}

class ActivitiesScreenState extends State<ActivitiesScreen> {
  TextEditingController controller = TextEditingController();
  List<Activity> selectedActivities = List<Activity>();
  Map<String, dynamic> planMap = createPlanMap();
  String planInputText = "";

  void updatePlanTitle(String text) {
    setState(() {
      if (text.isEmpty) {
        planInputText = "";
      } else {
        planInputText = text;
      }
    });
  }

  void openDatePicker() {
    planMap['uuid'] = "plan1";
    planMap['createdBy'] = "user1";
    planMap['planInputText'] = planInputText;
    planMap['activities'] = selectedActivities;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DatesScreen(),
        settings: RouteSettings(
          name: "DatesScreen",
          arguments: {
            "planMap": planMap,
          }
        )
      ),
    );
  }

  bool isSelected(Activity activity) {
    return selectedActivities.map((a) => a.uuid).toList().contains(activity.uuid);
  }

  void toggleActivity(Activity activity) {
    setState(() {
      if (isSelected(activity)) {
        selectedActivities.removeWhere((a) => a.uuid == activity.uuid);
      } else {
        selectedActivities.add(activity);
      }
//      var planTitle = selectedActivities.isEmpty
//          ? "" : selectedActivities.map((a) => a.description).join(", ");
//      controller.text = planTitle;
//      planInputText = planTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("New Plan", style: TextStyle(color: Colors.white)),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 24.0, bottom: 0.0, left: 0.0, right: 0.0),
              color: Colors.white,
              height: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: TextField(
                      enabled: true,
                      controller: controller,
                      textAlign: TextAlign.center,
                      onChanged: updatePlanTitle,
                      style: TextStyle(color: Colors.blue, fontSize: 32.0, decoration: TextDecoration.none),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.red,
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "What's the plan?"
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('activities').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return LinearProgressIndicator();
                      return _buildList(context, snapshot.data.documents);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  height: 64,
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text("Continue", style: TextStyle(fontSize: 24, color: Colors.white)),
                    disabledColor: Color(0xFF777777),
                    onPressed: selectedActivities.isNotEmpty || planInputText.isNotEmpty ? openDatePicker : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
      physics: new NeverScrollableScrollPhysics(),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final activity = Activity.fromSnapshot(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 0.0, right: 0.0),
            child: Column(
              children: <Widget>[
                Text(
                  activity.graphic, style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 32.0, decoration: TextDecoration.none),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    activity.description,
                    style: TextStyle(color: isSelected(activity) ? Colors.white : Colors.grey, fontSize: 14.0, decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: Colors.transparent,
                width: 1,
                style: BorderStyle.solid
              ),
            ),
            color: isSelected(activity) ? Colors.blue : Colors.white, // sets background color, default Colors.white
            onPressed: () {
              toggleActivity(activity);
            }
          ),
      ],
    );
  }
}