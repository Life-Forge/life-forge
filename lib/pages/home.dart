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
import 'package:life_forge/pages/home_v2.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = 'User'; //CHECK
  final NotificationService notificationService =
      NotificationService(); // Initialize NotificationService

  final List<String> labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S']; //CHECK

  List<String> featuresToTrack = [
    'Feature1',
    'Feature2',
    'Feature3',
    'Feature4',
    'Feature5',
  ]; //CHECK

  List<String> adjustedLabels = [];
  List<num> featuresData = [0, 0, 0, 0, 0]; //CHECK
  num overallLevel = 1; //CHECK
  num streak =
      1; // look at last and second last entry in the database and process
  List<double> weeklyProgress = [0,0,0,0,0,0,0]; // get from db
  /*
  For now, we are gonna just put the percentage work for each day for week's progress
  

  */

  final String quote =
      'You are doing great! Keep it up!'; // get from a text file or smtn....

  List<Map<String, String>> questionsParameterPair =
      []; // get from parameter db -- CHECK

  double currentPoints = 0; //CHECk
  final double pointsForNextLevel = 150; // get from levels definition
  final double pointsForoverallLevel = 0;
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> goalsDetails = [];

  void labelText() {
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    weekDays = weekDays.reversed.toList(); // Reverse first

    DateTime now = DateTime.now();
    int todayWeekday = now.weekday; // 1 = Monday, 7 = Sunday

// Adjust for reversed list
    int reversedIndex = (7 - todayWeekday) % 7;

    adjustedLabels = [
      ...weekDays.sublist(reversedIndex),
      ...weekDays.sublist(0, reversedIndex),
    ];

  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProgressData();
    streakUpdater();
  }

  void streakUpdater() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    streak =
        prefs.getInt('streak') ?? 0; // Provide a default value of 0 if null
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
            )[x]['sliderValue']).toDouble();
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
            )[i]['sliderValue']).toDouble();
        weeklyProgress[x] += points / featuresData.length;
      }
    }


  }
  void printInChunks(String text) {
    final pattern = RegExp('.{1,200}'); // 800 characters per chunk
    int key = 1;
    for (var match in pattern.allMatches(text)) {
      print('key=$key ${match.group(0)}');
      key++;
    }  
  }


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
    //printInChunks('key=1C $userAllData');

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

  /* 
  
  userData pattern: 
  [
    {
      "name": "User",
      "age": 16,
      "birthday" : "01/01/2005",      
    }
  ]

  goalsDetails pattern:
  [
    {
      'name': "Goal1",
      'description': "This is a test goal",
      'level': 1,
      'points': 100,
      'dateAdded' : "01/01/2021",
      'dateCompleted' : "01/01/2021", (null for not completed)
      'trackedType': "Time", ( time/ number/ boolean/ effort/ etc.)
      'trackedName': 'number of questions' ,
    }, .....    
  ]

  Userdailydata pattern: 
  [
    { 'name' : 'Goal1',
      'points' : 97,
      'textReflection' : 'I did well today',
    }, ....
    
  ]

  */

  /* 
  Make all absolute values a variable tht is called in here. and make the graphs dynamic to number of parameters being tracked. -- done

  action buttons on app bar -- done

  Make the UI dynamic for all different devices and different screen sizes. -- kinda did tht

  put everything in a scroll view 
  */

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    labelText();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7FF),
        title: Center(
          child: Text(
            'Hi! $username',
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
        leading: IconButton(icon: Icon(Icons.share), onPressed: () {}),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: material.Column(
                children: [
                  const Text(
                    'Your Weekly Progress: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            /*
            Add level of each goal below the name of the goal.
            Add padding for the name and level of the goal.

            */
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
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

                        data: [featuresData],
                        ticks: [1, 2, 3, 4, 5],
                        graphColors: [Colors.red],
                        sides: featuresData.length,
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center the row
                    children: [
                      SizedBox(
                        width: screenWidth * 0.8, // Adjust width as needed
                        child: LinearProgressIndicator(
                          value:
                              (currentPoints -
                                  (100 * overallLevel * overallLevel)) /
                              ((100 * (overallLevel + 1) * (overallLevel + 1)) -
                                  (100 * overallLevel * overallLevel)),
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ), // Space between progress bar and text
                      Text(
                        '$overallLevel', // Example text
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    'Streak: \n \t   $streak',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.05,
                      left: 20.0,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: screenHeight * 0.09,

                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,

                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[0],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[1],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[2],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[3],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 4,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[4],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 5,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[5],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 6,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyProgress[6],
                                    color: Colors.blue,
                                    width: screenWidth * 0.05,
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ],
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: 8.0,
                                      ), // Adjust spacing
                                      child: Text(
                                        adjustedLabels[value
                                            .toInt()], // Get custom label from list
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.03),
                    child: Text(
                      quote,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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
                      child: Text('Record Today\'s Progress'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index==1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeV2()),
            );

          }
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'My Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
