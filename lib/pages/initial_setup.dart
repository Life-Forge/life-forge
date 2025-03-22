//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:life_forge/database/app_database.dart';
import 'package:life_forge/utility/json_translator.dart';
import 'package:flutter/material.dart' as f;
//import 'package:life_forge/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_forge/main.dart'; // Import MyApp for restarting the app

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}


class _SetupScreenState extends State<SetupScreen> {

    Future<void> completeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_time', false);
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: f.Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Center(
              child: const Text('Welcome to LifeForge!', 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  )
                ),
            ),

            Padding(padding: const EdgeInsets.all(20.0),
              child: const Text("Welcome! Let's set things up to personalize your experience. It'll only take a moment, and then you're all set to go! 🚀", 
                style: TextStyle(
                  fontSize: 16,
                  )
                ),
            ),

            ElevatedButton(
              onPressed: () {
                completeSetup();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => _SetupScreen2()),
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

class _SetupScreen2 extends StatefulWidget {
  const _SetupScreen2();

  @override
  State<_SetupScreen2> createState() => __SetupScreen2State();
}

class __SetupScreen2State extends State<_SetupScreen2> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child:  f.Column(
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Padding(padding: const EdgeInsets.all(20.0),
              child: const Text("Let's get started by setting up your personal data.", 
                style: TextStyle(
                  fontSize: 16,
                  )
                ),
            ),

            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => _SetupScreen3()),
                );
              },
              child: const Text('Continue'),
            ),



          ],
        )
      )
    )
    );
  }
}







void showFullScreenPopup(BuildContext context) {
  //List<Map<String,String>> questionsParameterPairs = questionsParameterPair;
  
  showDialog(
    context: context,    
    barrierColor: Colors.black.withAlpha(108),
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black.withAlpha(204),
        insetPadding: EdgeInsets.all(20.0),
        child: _SetupScreen3(),
      );
    },
  );
}

class _SetupScreen3 extends StatefulWidget {
  //final List<Map<String,String>> questionsParameterPair;
  //const _SetupScreen3(this.questionsParameterPair);
  @override
  // ignore: no_logic_in_create_state
  _SetupScreen3State createState() => _SetupScreen3State();
}

class _SetupScreen3State extends State<_SetupScreen3> {
  int currentQuestion = 0;
  double sliderValue = 0;
  //final List<Map<String,String>> questions;
  //_SetupScreen3State(this.questions);
  TextEditingController goalNameController = TextEditingController();
  TextEditingController goalDiscriptionController = TextEditingController();
  TextEditingController goalQuestionController = TextEditingController();
  TextEditingController goalParameterController = TextEditingController();
  List<Map<String , dynamic>> goals = [];
  
  // questions should be loaded from HomePage when the popup is called -- done

  // patern : [[question, parameter],......]

  // dialog needs to be made smaler -- done
  // close button for dialog -- done
  // way to send out data
  

  @override
  void initState() {
    super.initState();
    
  }





  @override
  Widget build(BuildContext context) {
    
    return Scaffold( 
      body: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20),
      child: f.Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Your Goal - $currentQuestion',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: goalNameController,
            decoration: InputDecoration(
              hintText: "Enter the name of your Goal...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black.withAlpha(108),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: Colors.white),
          ),


          SizedBox(height: 20),



          TextField(
            controller: goalDiscriptionController,
            decoration: InputDecoration(
              hintText: "Enter the discription of your Goal...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black.withAlpha(108),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: Colors.white),
          ),

          TextField(
            controller: goalQuestionController,
            decoration: InputDecoration(
              hintText: "Enter the name of your Goal...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black.withAlpha(108),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: Colors.white),
          ),

          TextField(
            controller: goalParameterController,
            decoration: InputDecoration(
              hintText: "Enter the name of your Goal...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black.withAlpha(108),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: Colors.white),
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _prevQuestion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: Text("Previous"),
              ),
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(currentQuestion == 5 ? "Finish" : "Next"),
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        
        ],
      ),
    ));
  }
    
  void _nextQuestion() {
  //error
  goals.add( {
    "name": goalNameController.text,
    "description": goalDiscriptionController.text,
    "question": goalQuestionController.text,
    "parameter": goalParameterController.text,
    "dateAdded": DateTime.now().toString(),
    "points": 0,
    "level": 0,
  });


  if (currentQuestion < 5) {    
    setState(() {
      currentQuestion++;
      sliderValue = 0;
      goalNameController.clear();
      goalDiscriptionController.clear();
      goalQuestionController.clear();
      goalParameterController.clear();
    });
  } else {
    // call function with proper answers variable 
    //print(goals);
    insertUserData(goals);
    
    //Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp(firstTime: false,)),
    );
    //printUserData();
    //it works
  }
  }

/*
Future<void> printUserData() async {
  final database = AppDatabase(); // Initialize your database
  final allUserDailyData = await database.getAllUserDailyData();
  print(allUserDailyData);
}
*/

  Future<void> insertUserData(List<Map<String, dynamic>> goals) async {
    final database = AppDatabase(); // Initialize your database

      final goalsEntry = UserdataCompanion(
      id: Value(1),
      personalData: Value(mapListToJsonString([
        {'name': "TestUser"}
      ])),
      goalsDetails: Value(mapListToJsonString(goals)),
      userLevel: Value(0),
      userPoints: Value(0),
      
      /*personalData: Value(answer['text']),
      goalsDetails: Value(answer['text']),
      userLevel: Value(answer['sliderValue'].toInt()),
      userPoints: Value(answer['sliderValue'].toInt()),*/
      );

      await database.into(database.userdata).insert( goalsEntry );
      

    }
  


  void _prevQuestion() {
  if (currentQuestion > 0) {
    setState(() {
      currentQuestion--;
      sliderValue = 0;
      goalDiscriptionController.clear();
      goalNameController.clear();
      goalQuestionController.clear();
      goalParameterController.clear();
    });
  }
  }
  
}

/* 

Okay, the input works. Name needs to be fixed. 
Set initial points 
Set initial level
Fix data showing up in the bar graph

*/