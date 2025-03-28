import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;
import 'package:life_forge/utility/json_translator.dart';
import 'package:life_forge/database/app_database.dart';

void showFullScreenPopup(BuildContext context, questionsParameterPair) {
  List<Map<String, String>> questionsParameterPairs = questionsParameterPair;

  showDialog(
    context: context,
    barrierColor: Colors.black.withAlpha(108),
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black.withAlpha(204),
        insetPadding: EdgeInsets.all(20.0),
        child: _QuestionnairePopup(questionsParameterPairs),
      );
    },
  );
}

class _QuestionnairePopup extends StatefulWidget {
  final List<Map<String, String>> questionsParameterPair;
  const _QuestionnairePopup(this.questionsParameterPair);
  @override
  // ignore: no_logic_in_create_state
  _QuestionnairePopupState createState() =>
  // ignore: no_logic_in_create_state
  _QuestionnairePopupState(questionsParameterPair);
}

class _QuestionnairePopupState extends State<_QuestionnairePopup> {
  int currentQuestion = 0;
  double sliderValue = 0;
  final List<Map<String, String>> questions;
  _QuestionnairePopupState(this.questions);
  TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> answers = [];

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
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20),
      child: f.Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            questions[currentQuestion]['question'] ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Enter your answer...",
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black.withAlpha(108),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          Text(
            "Parameter Tracked:${questions[currentQuestion]['parameter']} \n Rate progress(0-100)",
            style: TextStyle(color: Colors.white),
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            divisions: 50,
            label: sliderValue.round().toString(),
            onChanged: (value) {
              setState(() {
                sliderValue = value;
              });
            },
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
                child: Text(
                  currentQuestion == questions.length - 1 ? "Finish" : "Next",
                ),
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
    );
  }

  void _nextQuestion() {
    //error
    answers.add({
      "name": questions[currentQuestion]['name'],
      "text": textController.text,
      "sliderValue": sliderValue,
    });

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        sliderValue = 0;
        textController.clear();
      });
    } else {
      // call function with proper answers variable

      insertUserDailyData(answers);
      Navigator.pop(context);
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

  Future<void> insertUserDailyData(List<Map<String, dynamic>> answers) async {
    final database = AppDatabase(); // Initialize your database

    final userEntry = UserdailydataCompanion(
      date: Value(DateTime.now()),
      dailyData: Value(mapListToJsonString(answers)),
      /*personalData: Value(answer['text']),
      goalsDetails: Value(answer['text']),
      userLevel: Value(answer['sliderValue'].toInt()),
      userPoints: Value(answer['sliderValue'].toInt()),*/
    );

    await database.insertUserDailyData(userEntry);
  }

  void _prevQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        sliderValue = 0;
        textController.clear();
      });
    }
  }
}
