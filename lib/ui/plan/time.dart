import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetable/models/planTime.dart';

class TimeScreen extends StatefulWidget {
  @override
  TimeScreenState createState() {
    return new TimeScreenState();
  }
}

class TimeScreenState extends State<TimeScreen> {
  Map<String, dynamic> planMap;
  bool imperial = true;

  static Timestamp epochStart = Timestamp.fromMillisecondsSinceEpoch(0);
  static Timestamp epochEnd = Timestamp.fromMillisecondsSinceEpoch(32503726800000); // year 3000
  static Timestamp selectedStartTime = epochStart;
  static Timestamp selectedEndTime = epochEnd;

  List<String> weekDays = List.of(["M", "T", "W", "Th", "F", "Sa", "Su"]);
  static Map<String, dynamic> selectedPlanTimeMap = createPlanTimeMap(selectedStartTime, selectedEndTime);
  PlanTime selectedPlanTime = PlanTime.fromMap(selectedPlanTimeMap);

  void _saveAndReturnToPlansList() {
    planMap['time'] = selectedPlanTime;

    // Push saved plan object to Firebase

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  bool isStartTimeValid(Timestamp startTime) {
    if (selectedEndTime != epochEnd) { // end time selected
      if (selectedEndTime.millisecondsSinceEpoch <= startTime.millisecondsSinceEpoch) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  bool isEndTimeValid(Timestamp endTime) {
    if (selectedStartTime != epochStart) { // start time selected
      if (selectedStartTime.millisecondsSinceEpoch >= endTime.millisecondsSinceEpoch) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  bool timestampsEqual(Timestamp first, Timestamp second) {
    return first.millisecondsSinceEpoch == second.millisecondsSinceEpoch;
  }

  bool selectStartTime(Timestamp time) {
    if (timestampsEqual(selectedStartTime, time)) {
      selectedStartTime = epochStart;
      return false;
    } else if (isStartTimeValid(time)) {
      selectedStartTime = time;
      return true;
    } else {
      return false;
    }
  }

  bool selectEndTime(Timestamp time) {
      if (timestampsEqual(selectedEndTime, time)) {
        selectedEndTime = epochEnd;
        return false;
      } else if (isEndTimeValid(time)) {
        selectedEndTime = time;
        return true;
      } else {
        return false;
      }
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    planMap = args['planMap'];
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 64.0, bottom: 0.0, left: 0.0, right: 0.0),
        color: Colors.white,
        height: double.maxFinite,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:16.0, bottom: 32.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:0.0, bottom: 0.0),
                    child: Text(
                      "Meet sometime between",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 27.0, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                    ),
                  ),
                  _buildTimesList(),
                  Container(
                    padding: EdgeInsets.only(top:0.0, bottom: 0.0),
                    child: Text(
                      "and",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 27.0, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
                    ),
                  ),
                  _buildTimesList(start: false),
                  Container(
                    padding: EdgeInsets.only(top: 36.0, bottom: 24.0),
                    child: Divider(),
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
                    child: Text("Continue", style: TextStyle(fontSize: 24)),
                    textColor: Colors.black,
                    color: Color(0xFF333333),
                    disabledColor: Color(0xFF777777),
                    onPressed: selectedStartTime != epochStart && selectedEndTime != epochEnd ? _saveAndReturnToPlansList : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimesList({bool start = true/*, bool hardStop = false*/}) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 64.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: buildWidgets(imperial, start),
        )
    );
  }

  List<Widget> buildWidgets(bool imperial, bool start) {
    List<Widget> widgets = [];
    List times = buildTimesList();
    times.map((time) {
      var color = start ? Colors.blue : Colors.red;
      var v = timeWidget(Icons.location_on, time, color, start);
      widgets.add(v);
    }).toList();
    return widgets;
  }

  Widget timeWidget(IconData icon, String text, MaterialColor color, bool start) {
    var date = DateTime.fromMillisecondsSinceEpoch(planMap['dates'].first.date.millisecondsSinceEpoch);
    var hour = int.parse(text.substring(0, 2));
    var minutes = int.parse(text.substring(3, 5));
    date = new DateTime(date.year, date.month, date.day, hour, minutes, 0, 0, 0);
    var timestamp = Timestamp.fromDate(date);
    var isSelected = timestampsEqual(start ? selectedStartTime : selectedEndTime, timestamp);
    return Container(
      width: 100.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        elevation: 2.0,
          child: FlatButton(
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: new Text(
              text,
              style: TextStyle(color: Color(0xFF555555), fontSize: 16.0, decoration: TextDecoration.none),
            ),
            textColor: Color(0xFF555555),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 1,
                  style: BorderStyle.solid
              ),
            ),
            color: isSelected ? Colors.transparent : Color(0xFFDDDDDD),
            onPressed: () => setState(() {
              if (start) {
                isSelected = selectStartTime(timestamp);
              } else {
                isSelected = selectEndTime(timestamp);
              }
            }),
          ),
      ),
    );
  }

  List buildTimesList({bool imperial = false}) {
    if (imperial) {
      return [
        "12:00 AM", "12:30 AM", "01:00 AM", "01:30 AM", "02:00 AM", "02:30 AM",
        "03:00 AM", "03:30 AM", "04:00 AM", "04:30 AM", "05:00 AM", "05:30 AM",
        "06:00 AM", "06:30 AM", "07:00 AM", "07:30 AM", "08:00 AM", "08:30 AM",
        "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
        "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM",
        "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM",
        "06:00 PM", "06:30 PM", "07:00 PM", "07:30 PM", "08:00 PM", "08:30 PM",
        "09:00 PM", "09:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM",
      ];
    } else {
      return [
        "00:00", "00:30", "01:00", "01:30", "02:00", "02:30", "03:00", "03:30",
        "04:00", "04:30", "05:00", "05:30", "06:00", "06:30", "07:00", "07:30",
        "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
        "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30",
        "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30",
        "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "23:30",
      ];
    }
  }
}