import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart'
    as flutter_radar_chart;
import 'package:life_forge/database/app_database.dart';

import 'package:life_forge/utility/notification_service.dart';

import 'package:life_forge/widgets/questionare.dart';
import 'package:life_forge/utility/json_translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> myUserData(int userId, String fieldName) async {
  final db = AppDatabase();
  final query =
      db.select(db.userdata)
        ..where((tbl) => tbl.id.equals(userId))
        ..limit(1);

  final result = await query.getSingleOrNull();
  //List<UserdataData>? userdatatable = await db.getAllUserData();
  //print('key=B3 $userdatatable');

  if (result == null) return null; // No data found

  switch (fieldName) {
    case 'personalData':
      return result.personalData;
    case 'goalsDetails':
      return result.goalsDetails;
    case 'userPoints':
      return result.userPoints.toString();
    case 'userLevel':
      return result.userLevel.toString();
    default:
      return null; // Handle invalid field names
  } // Returns a JSON string
}

Future<List<UserdailydataData>> getxLatestDailyReadings(int x) async {
  final db = AppDatabase();
  return await (db.select(db.userdailydata)
        ..orderBy([
          (u) => OrderingTerm.desc(u.id),
        ]) // Order by ID in descending order
        ..limit(x)) // Get up to x entries
      .get();
}

void printInChunks(String text) {
  final pattern = RegExp('.{1,800}'); // 800 characters per chunk
  int key = 1;
  for (var match in pattern.allMatches(text)) {
    print('key=$key ${match.group(0)}');
    key++;
  }
}

class HomeV2 extends StatefulWidget {
  const HomeV2({super.key});

  @override
  State<HomeV2> createState() => _HomeV2State();
}

class _HomeV2State extends State<HomeV2> {
  // INITIALIZING VARIABLES
  double currentPoints = 0;
  int overallLevel = 0;
  String username = '';
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> goalsDetails = [];
  List<String> featuresToTrack = [
    'Feature1',
    'Feature2',
    'Feature3',
    'Feature4',
    'Feature5',
  ];
  List<Map<String, String>> questionsParameterPair = [];
  List<String> adjustedLabels = [];
  List<num> featuresData = [0, 0, 0, 0, 0]; //CHECK
  List<List<dynamic>> userPerfomanceData = [];
  num streak =
      1; // look at last and second last entry in the database and process
  List<double> weeklyProgress = [0, 0, 0, 0, 0, 0, 0];
  final NotificationService notificationService = NotificationService();

  // ALL COLORS
  final Color primaryColor = const Color(0xff000000);
  final Color secondaryColor = const Color.fromARGB(255, 15, 15, 15);
  final Color textColor = const Color(0xfff8f8f2);
  // ignore: deprecated_member_use
  final Color secondaryTextColor = const Color(0xffdda0dd);
  Color graphColors = Colors.red;

  // FUNCTIONS
  Future<void> _loadUserData() async {
    String? userDataRaw = await myUserData(
      1,
      'personalData',
    ); // Replace 1 with actual user ID
    //String? levelStr = await myUserData(1, 'userLevel');
    String? goalsDetailsRaw = await myUserData(1, 'goalsDetails');
    String? userPointsRaw = await myUserData(1, 'userPoints');
    //print('$userPointsRaw:1A:$levelStr');
    currentPoints = double.parse(userPointsRaw ?? '0');
    if (true) {
      overallLevel = sqrt(currentPoints / 100).floor();
      //print('key=1A $overallLevel');
      //print('key=1B $currentPoints');
    } //else {
    //overallLevel = num.parse(levelStr);
    // }
    var db = AppDatabase();
    var userAllData = await db.getAllUserDailyData();

    if (goalsDetailsRaw != null) {
      setState(() {
        goalsDetails = jsonStringToMapList(goalsDetailsRaw);
        featuresToTrack = List.generate(
          goalsDetails.length,
          (index) => goalsDetails[index]['name'],
        );
      });
    }

    if (userDataRaw != null) {
      setState(() {
        userData = jsonStringToMapList(userDataRaw);
      });
    }

    if (userPointsRaw != null) {
      currentPoints = double.parse(userPointsRaw);
    }

    if (userData.isNotEmpty) {
      username = userData[0]['name'];
    }

    if (goalsDetailsRaw != null) {
      goalsDetails = jsonStringToMapList(goalsDetailsRaw);
      //print('key=B2 $goalsDetails');
      for (var i = 0; i < goalsDetails.length; i++) {
        questionsParameterPair.add({
          'question': goalsDetails[i]['question'] ?? '',
          'parameter': goalsDetails[i]['parameter'] ?? '',
          'name': goalsDetails[i]['name'] ?? '',
        });
      }
      //print('key=B1 $questionsParameterPair');
    }
  }

  Future<void> _loadProgressData() async {
    List<UserdailydataData> userDailyDataRaw = await getxLatestDailyReadings(7);

    featuresData = List.generate(
      jsonStringToMapList(userDailyDataRaw[0].dailyData).length,
      (index) => 0,
    );

    for (var i = 0; i < userDailyDataRaw.length; i++) {
      for (var x = 0; x < featuresData.length; x++) {
        double points =
            (jsonStringToMapList(
                  userDailyDataRaw[i].dailyData,
                )[x]['sliderValue'])
                .toDouble();
        featuresData[x] += points / 100;
      }
    }

    for (var i = 0; i < featuresData.length; i++) {
      featuresData[i] = featuresData[i] / userDailyDataRaw.length;
      featuresData[i] = featuresData[i] * 5;
    }

    weeklyProgress = List.generate(7, (index) => 0);

    for (var i = 0; i < featuresData.length; i++) {
      for (var x = 0; x < userDailyDataRaw.length; x++) {
        double points =
            (jsonStringToMapList(
                  userDailyDataRaw[x].dailyData,
                )[i]['sliderValue'])
                .toDouble();
        weeklyProgress[x] += points / featuresData.length;
      }
    }

    List<UserdailydataData> rawdata = await getxLatestDailyReadings(14);
    userPerfomanceData = List.generate(rawdata.length, (index) => [0, 0]);
    for (var i = 0; i < rawdata.length; i++) {
      for (var x = 0; x < featuresData.length; x++) {
        double points =
            (jsonStringToMapList(rawdata[i].dailyData)[x]['sliderValue'])
                .toDouble();
        userPerfomanceData[i][0] += points / featuresData.length;
      }
      if (userPerfomanceData[i][0] > 30) {
        userPerfomanceData[i][1] = 0;
      }

      printInChunks('key=2D $rawdata');
      print('key=2E ${rawdata.length}');
    }
    double score_avg = 0;
    for (var i = 0; i < featuresData.length; i++) {
      score_avg += featuresData[i] / featuresData.length;
    }

    if (score_avg > 30) {
      graphColors = Color(0xff008b8b);
    } else if (score_avg > 20) {
      graphColors = Colors.yellow;
    } else {
      graphColors = Color(0xffc51e3a);
    }

    setState(() {
      featuresData = featuresData;
      userPerfomanceData = userPerfomanceData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProgressData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          'Hi! $username',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
        leading: IconButton(icon: Icon(Icons.share), onPressed: () {}),
        iconTheme: IconThemeData(
          color: textColor, // Change the color of the icons
        ),
      ),
      body: SafeArea(
        child: material.Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: material.Column(
                children: [
                  Text(
                    'Your Weekly Progress: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            /*
            Add level of each goal below the name of the goal.
            Add padding for the name and level of the goal.

            */
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: material.Column(
                children: [
                  Center(
                    child: SizedBox(
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.8,
                      child: flutter_radar_chart.RadarChart(
                        features:
                            (featuresToTrack.map((feature) {
                              return feature.replaceAll(
                                " ",
                                "\n",
                              ); // Break long words into two lines
                            }).toList()),
                        featuresTextStyle: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),

                        data: [
                          featuresData,
                          [5, 5, 5, 5, 5],
                        ],
                        ticks: [1, 2, 3, 4, 5],
                        graphColors: [graphColors, secondaryColor],

                        sides: featuresData.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: screenWidth * 0.5,
                  width: screenWidth * 0.5,
                  child: CircularProgressIndicator(
                    value:
                        (currentPoints - (100 * overallLevel * overallLevel)) /
                        ((100 * (overallLevel + 1) * (overallLevel + 1)) -
                            (100 *
                                overallLevel *
                                overallLevel)), // value from 0.0 to 1.0
                    backgroundColor: Colors.grey[800],
                    strokeWidth: 50.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xffad5691),
                    ),
                  ),
                ),
                material.Column(
                  children: [
                    Text(
                      'Level',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '$overallLevel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '$currentPoints/${100 + (300 * overallLevel * overallLevel)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            SizedBox(
              height: screenHeight * 0.1,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userPerfomanceData.length,
                itemBuilder: (context, index) {
                  double value = userPerfomanceData[index][0];

                  Color bgcolor;
                  if (value > 30) {
                    bgcolor = Color(0xff008b8b);
                  } else if (value > 20) {
                    bgcolor = Colors.yellow;
                  } else {
                    bgcolor = Color(0xffc51e3a);
                  }
                  return Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.1,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgcolor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        'Day ${index + 1}\n${userPerfomanceData[index][0].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            material.Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryTextColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: screenHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed:
                          () async => {
                            showFullScreenPopup(
                              context,
                              questionsParameterPair,
                            ),
                            //print('key=1A notification'),
                            await notificationService.scheduleDailyNotification(
                              id: 1,
                              title: "Daily Reminder",
                              body: "It's 9 AM! Time for your daily task.",
                              hour: 21,
                              minute: 00,
                            ),
                          },
                      child: Text(
                        'Record Today\'s Progress',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
