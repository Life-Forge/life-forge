import 'package:flutter/material.dart';
import 'package:life_forge/pages/home.dart';
import 'package:life_forge/utility/notification_service.dart';

import 'package:timezone/data/latest.dart' as tz;
//import 'package:drift/drift.dart';
//import 'package:life_forge/utility/json_translator.dart';
//import 'database/app_database.dart'; // Ensure this contains the required Drift database setup

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'pages/initial_setup.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await insertTestData(db); // DEBUG: Insert test data (Remove before launch)
  runApp(const MyApp());
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firstTime = await isFirstTime();
  final notificationService = NotificationService();
  tz.initializeTimeZones();
  setLocalLocation(getLocation('Asia/Kolkata'));



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
