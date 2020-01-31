import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetable/models/planDate.dart';
import 'package:meetable/ui/plan/time.dart';

class DatesScreen extends StatefulWidget {
  @override
  DatesScreenState createState() {
    return new DatesScreenState();
  }
}

class DatesScreenState extends State<DatesScreen> {
  Map<String, dynamic> planMap;
  List<PlanDate> selectedDates = List<PlanDate>();

  DateTime _validNow() {
    DateTime now = DateTime.now();
    // If it is less than 2 hours until midnight, consider tomorrow as today
    return now.hour < 22 ? now : now.add(Duration(days: 1));
  }

  void _openTimePicker() {
    planMap['dates'] = selectedDates;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => TimeScreen(),
          settings: RouteSettings(
              name: "TimeScreen",
              arguments: {
                "planMap": planMap,
              }
          )
      ),
    );
  }

  bool _isSelected(PlanDate planDate) {
    return selectedDates.map((d) => d.uuid).toList().contains(planDate.uuid);
  }

  bool _isAvailable(PlanDate planDate) {
    return planDate.status == "available";
  }

  void _toggleDate(PlanDate planDate) {
    if (!_isAvailable(planDate)) {
      return;
    }
    setState(() {
      if (_isSelected(planDate)) {
        selectedDates.removeWhere((d) => d.uuid == planDate.uuid);
      } else {
        selectedDates.add(planDate);
      }
    });
  }

  int _todayIndex() {
    // handle difference between platform week day index (mon-sun) and custom index (sun-sat)
    var dayOfTheWeek = _validNow().weekday;
    return dayOfTheWeek == 7 ? 0 : dayOfTheWeek;
  }

  List<Widget> _buildHeader() {
    return [
      Container(
        alignment: Alignment.center,
        child: Text(
          "S",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "M",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "T",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "W",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "T",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "F",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "S",
          style: TextStyle(color: Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
        ),
      ),
    ];
  }

  Widget _buildListItem(BuildContext context, PlanDate planDate, {bool today = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Text(
            planDate.date.toDate().day.toString(),
            style: TextStyle(color: _isSelected(planDate) ? Colors.white : _isAvailable(planDate) ? Colors.blue : Color(0xFF999999), fontSize: 16.0, decoration: TextDecoration.none),
          ),
          textColor: Color(0xFF555555),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48.0),
            side: BorderSide(
                color: _isAvailable(planDate) ? Colors.blue : Colors.transparent,
                width: 1,
                style: BorderStyle.solid
            ),
          ),
          color: _isSelected(planDate) ? Colors.blue : today ? Color(0x332196F3) : Colors.transparent,
          onPressed: () {
            _toggleDate(planDate);
          },
        ),
      ],
    );
  }

  List<Widget> _buildListItems(BuildContext context) {
    List<Widget> widgets = [];
    List<Widget> header = _buildHeader();
    var todayIndex = _todayIndex();
    //var todayIndex = 2;

    List<Widget> threeWeeks = [];
    if (todayIndex == 0) {
      for (var i = 0; i < 21; i++) {
        var diffDays = todayIndex + i;
        var diffDate = _validNow().add(Duration(days: diffDays));
        var planDateMap = createPlanDateMap(i.toString(), Timestamp.fromDate(diffDate));
        var planDate = PlanDate.fromMap(planDateMap);
        var item = _buildListItem(context, planDate, today: i == todayIndex);
        threeWeeks.add(item);
      }
    } else {
      for (var i = 0; i < todayIndex; i++) {
        var diffDays = todayIndex - i;
        var diffDate = _validNow().subtract(Duration(days: diffDays));
        var planDateMap = createPlanDateMap(i.toString(), Timestamp.fromDate(diffDate), status: "unavailable");
        var planDate = PlanDate.fromMap(planDateMap);
        var item = _buildListItem(context, planDate);
        threeWeeks.add(item);
      }
      for (var i = todayIndex; i < 21; i++) {
        var diffDays = i - todayIndex;
        var diffDate = _validNow().add(Duration(days: diffDays));
        var planDateMap = createPlanDateMap(i.toString(), Timestamp.fromDate(diffDate));
        var planDate = PlanDate.fromMap(planDateMap);
        var item = _buildListItem(context, planDate, today: i == todayIndex);
        threeWeeks.add(item);
      }
    }

    widgets.addAll(header);
    widgets.addAll(threeWeeks);
    return widgets;
  }

  Widget _buildList(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
      physics: new NeverScrollableScrollPhysics(),
      children: _buildListItems(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Plan", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 0.0, left: 0.0, right: 0.0),
          color: Colors.white,
          height: double.maxFinite,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top:8.0, bottom: 24.0),
                      child: Text(
                        "When you thinking?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 32.0, decoration: TextDecoration.none),
                      ),
                    ),
                    _buildList(context),
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
                      onPressed: selectedDates.isNotEmpty ? _openTimePicker : null,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    planMap = args['planMap'];
    return _buildBody(context);
  }
}