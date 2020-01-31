import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetable/models/activity.dart';
import 'package:meetable/models/plan.dart';
import 'package:meetable/models/planTime.dart';
import 'package:meetable/models/user.dart';
import 'package:meetable/models/planDate.dart';
import 'package:meetable/ui/plan/activities.dart';
import 'package:meetable/ui/plan/dates.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meetable',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue[800],
        accentColor: Colors.blue[600],
        secondaryHeaderColor: Colors.red
      ),
      home: MyHomePage(title: 'Meetable'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _openPlaceDetails(BuildContext context, Plan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // TODO
        builder: (_) => ActivitiesScreen(),
      ),
    );
  }

  void _addPlan() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      var userMap = {
        "uuid": "user1",
        "name": "Ivan",
        "status": "both",
      };
      var user = new User.fromMap(userMap);

      var planDateMap = {
        "date": Timestamp.fromDate(DateTime.parse('2019-11-05')),
        "status": "proposed",
      };

      var planDate = new PlanDate.fromMap(planDateMap);

      var planTimeMap = {
        "timeType": "specific",
        "startTime": Timestamp.fromDate(DateTime.parse('2019-11-05 10:00:00')),
        "endTime": Timestamp.fromDate(DateTime.parse('2019-11-05 11:30:00')),
        "hardStop": Timestamp.fromDate(DateTime.parse('2019-11-05 12:00:00')),
      };
      var planTime = new PlanTime.fromMap(planTimeMap);

      var planMap = {
        "uuid": "plan1",
        "createdBy": "user1",
        "planInputText": "drink beer with friends",
        "creationDate": Timestamp.fromDate(DateTime.parse('2019-11-04')),
        "isActive": true,
        "isDeleted": false,
        "users": [user],
        "activities": new List<Activity>(),
        "dates": [planDate],
        "time": planTime,
      };
      var plan = new Plan.fromMap(planMap);

      // create plan object with initial data, open new plan flow
      _openPlaceDetails(context, plan);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Tap '+' to add a plan",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlan,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
