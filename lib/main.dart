import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:life_forge/database/app_database.dart';
import 'package:life_forge/pages/home.dart';
import 'package:life_forge/utility/json_translator.dart';
import 'package:life_forge/utility/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'pages/initial_setup.dart';

Future<void> insertUserDailyData(List<Map<String, dynamic>> answers, int difference) async {
  final database = AppDatabase(); // Initialize your database
  DateTime today = DateTime.now();
  final userEntry = UserdailydataCompanion(
    
    date: Value(today.subtract(Duration(days: difference))),
    dailyData: Value(mapListToJsonString(answers)),
    /*personalData: Value(answer['text']),
      goalsDetails: Value(answer['text']),
      userLevel: Value(answer['sliderValue'].toInt()),
      userPoints: Value(answer['sliderValue'].toInt()),*/
  );

  await database.insertUserDailyData(userEntry);  
}

void callbackDispatcher() async {
  // This function is called when the app is resumed from the background
  // You can handle any necessary actions here
  
  

  //insertUserDailyData();
  DateTime date = DateTime.now();
  DateTime fdate = date.subtract(Duration(days: 1));
  String formattedDate = '${fdate.year}-${fdate.month}-${fdate.day }';
  final prefs = await SharedPreferences.getInstance();
  String? previousDate = prefs.getString('lastDate');
  
  int? streak = prefs.getInt('streak');


  List<String> parts = previousDate!.split('-');

  DateTime parsedDate = DateTime(
    int.parse(parts[0]),  // year
    int.parse(parts[1]),  // month
    int.parse(parts[2])   // day
  );


  if (date.difference(parsedDate).inDays >= 1) {
    prefs.setString('lastDate', formattedDate);
    // sub 1 from date
    streak = 0;
    //print('Key=1B $streak');
  } else {
    streak = (streak ?? 0) ;
    //print('Key=1C $streak');
  }
  //print('Key=1D $streak');
  prefs.setInt('streak', streak);
  
  // answers needs to be built from the database with values zero
  //insertUserDailyData({answers});
  //print('Key=1A $streak');
  int difference = date.difference(parsedDate).inDays;
  final database = AppDatabase(); // Initialize your database
  final lastRecord =
      await (database.userdailydata.select()
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
  //print('Key=2A $lastRecord');
  var i = 0;
  while (i < difference) {
    i++;
    List<Map<String, dynamic>> lastData = [];
    if (lastRecord != null) {
      // Update the last record with the new streak value
      lastData = jsonStringToMapList(lastRecord.dailyData);
    }

    List<Map<String, dynamic>> newData = [];
    //print('Key=2B ${lastData.length}');
    for (int x = 0; x < (lastData.length); x++) {
      newData.add({'name': lastData[x]['name'], 'sliderValue': 0.0, 'text': ''});
    }
    insertUserDailyData(newData, (i+1));
  } 
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firstTime = await isFirstTime();
  final notificationService = NotificationService();
  tz.initializeTimeZones();
  setLocalLocation(getLocation('Asia/Kolkata'));
  callbackDispatcher();
  // In your main or app initialization
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(MyApp(firstTime: firstTime));
}

class MyApp extends StatelessWidget {
  final bool firstTime;
  const MyApp({super.key, required this.firstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: //SetupScreen(),
          firstTime
              ? SetupScreen()
              : HomePage(), // DEBUG: Uncomment for initial setup
    );
  }
}

Future<bool> isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    prefs.setBool('isFirstTime', false);
  }
  return isFirstTime;
}

/*Future<void> insertTestData(AppDatabase db) async {
  final List<Map<String, dynamic>> rawPersonalData = [
    {
      "name": "TestUser",
      "age": 16,
      "preferences": {"motivation": "Challenges", "learning_style": "Visual"}
    }
  ];

  final List<Map<String, dynamic>> rawGoalsDetails = [
    {
      'name': "Goal1",
      'description': "This is a test goal",
      'question' : 'What is your goal1?',
    },
    {
      'name': "Goal2",
      'description': "This is another test goal",
      'question' : 'What is your goal2?',
    },
    {
      'name': "Goal3",
      'description': "This is a test goal",
      'question' : 'What is your goal?3',
    },
    {
      'name': "Goal4",
      'description': "This is another test goal",
      'question' : 'What is your goal?4',
    },{
      'name': "Goal5",
      'description': "This is a test goal",
      'question' : 'What is your goal?5',
    },
    
  ];

  // Pass values through the JSON translator
  final translatedPersonalData = mapListToJsonString(rawPersonalData);
  final translatedGoalsDetails = mapListToJsonString(rawGoalsDetails);

//  await db.delete(db.userdata).go(); 
/*
  await db.into(db.userdata).insert(
    UserdataCompanion.insert(
      id: Value(1),
      personalData: translatedPersonalData,
      goalsDetails: translatedGoalsDetails,
      userLevel: Value(7),
      userPoints: Value(1100),
    ),
  );
*/
}
*/
