import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;
import 'package:life_forge/database/app_database.dart';
import 'package:life_forge/main.dart';
import 'package:life_forge/utility/json_translator.dart';
import 'package:life_forge/utility/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  
  Future<void> completeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
    final notificationService = NotificationService();

// In your main or app initialization
    await notificationService.initialize();
    await notificationService.requestPermissions();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: f.Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'Welcome to LifeForge!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Welcome! Let's set things up to personalize your experience. It'll only take a moment, and then you're all set to go! 🚀",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                completeSetup();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupScreen2()),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class SetupScreen2 extends StatefulWidget {
  const SetupScreen2({super.key});

  @override
  State<SetupScreen2> createState() => _SetupScreen2State();
}

class _SetupScreen2State extends State<SetupScreen2> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: f.Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Let's get started by setting up your personal data.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('user_name', textController.text);
                  

                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetupScreen3(),
                    ),
                  );

                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetupScreen3 extends StatefulWidget {
  const SetupScreen3({super.key});

  @override
  State<SetupScreen3> createState() => _SetupScreen3State();
}

class _SetupScreen3State extends State<SetupScreen3> {
  final List<String> goalsOptions = [
    'Education',
    'Career',
    'Diet',
    'Relationships',
    'Financial',
    'Personal Growth',
    'Fitness',
  ];
  List<String> goalsSelected = [];
  List<bool> isSelected = [];
  List<Map<String, dynamic>> rawGoalsDetailsInput = [];
  @override
  void initState() {
    super.initState();
    isSelected = List.filled(goalsOptions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select your GOALS')),
      body: SafeArea(
        child: f.Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    shrinkWrap: true, // Prevents infinite height error
                    physics:
                        const NeverScrollableScrollPhysics(), // Uses parent scroll
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                    itemCount: goalsOptions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected[index] = !isSelected[index];
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isSelected[index] ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            goalsOptions[index],
                            style: TextStyle(
                              color:
                                  isSelected[index]
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity, // Full-width button
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      goalsSelected.clear(); // Clear previous selections
                      for (var i = 0; i < isSelected.length; i++) {
                        if (isSelected[i]) {
                          goalsSelected.add(goalsOptions[i]);
                        }
                      }

                      for (var i = 0; i < goalsSelected.length; i++) {
                        rawGoalsDetailsInput.add({
                          'name': goalsSelected[i],
                          'description': "Goal: improve in ${goalsSelected[i]}",
                          'question': 'How did you perform today?',
                        });
                      }

                      final db = AppDatabase();

                      insertTestData(db, rawGoalsDetailsInput);
                      //print('Selected Goals: $goalsSelected');
                    });

                    // Move to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(firstTime: false),
                      ), // Replace with your next screen
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// to input question and parameter
class SetupScreen4 extends StatefulWidget {
  const SetupScreen4({super.key});

  @override
  State<SetupScreen4> createState() => _SetupScreen4State();
}

class _SetupScreen4State extends State<SetupScreen4> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<void> insertTestData(AppDatabase db, rawGoalsDetailsInput) async {
  List<Map<String, dynamic>> rawGoalsDetails = [
    {
      'name': "Goal1",
      'description': "This is a test goal",
      'question': 'What is your goal1?',
    },
    {
      'name': "Goal2",
      'description': "This is another test goal",
      'question': 'What is your goal2?',
    },
    {
      'name': "Goal3",
      'description': "This is a test goal",
      'question': 'What is your goal?3',
    },
    {
      'name': "Goal4",
      'description': "This is another test goal",
      'question': 'What is your goal?4',
    },
    {
      'name': "Goal5",
      'description': "This is a test goal",
      'question': 'What is your goal?5',
    },
  ];

  final prefs = await SharedPreferences.getInstance();
  String? storedName = prefs.getString('user_name');

  List<Map<String, dynamic>> rawPersonalData = [
    {
      "name": storedName,
      "age": 99,
      "preferences": {"motivation": "Challenges", "learning_style": "Visual"},
    },
  ];

  if (rawGoalsDetailsInput != null) {
    rawGoalsDetails = rawGoalsDetailsInput;
  }

  // Pass values through the JSON translator
  final translatedPersonalData = mapListToJsonString(rawPersonalData);
  final translatedGoalsDetails = mapListToJsonString(rawGoalsDetails);

  final existingUser =
      await (db.select(db.userdata)
        ..where((t) => t.id.equals(1))).getSingleOrNull();

  if (existingUser == null) {
    // Insert the user if they don't exist
    await db
        .into(db.userdata)
        .insert(
          UserdataCompanion.insert(
            id: 1,
            personalData: translatedPersonalData,
            goalsDetails: translatedGoalsDetails,
            userLevel: Value(0),
            userPoints: Value(0),
          ),
        );
  } else {
    // Update the existing user
    await (db.update(db.userdata)..where((t) => t.id.equals(1))).write(
      UserdataCompanion(
        personalData: Value(translatedPersonalData),
        goalsDetails: Value(translatedGoalsDetails),
        userLevel: Value(0),
        userPoints: Value(0),
      ),
    );
  }
}
