import 'package:mobile/models/question.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TriviaViewModel {
  late String title;
  late Question question;

  // Constructor initializes title and leaves question uninitialized
  TriviaViewModel() {
    title = 'Trivia game';
    question = Question(
      id: 0,
      questionText: 'Loading...',
      options: <String, String>{
        'A': 'Loading...',
        'B': 'Loading...',
        'C': 'Loading...',
        'D': 'Loading...',
      },
      answer: 'A',
    );
  }

  Future<Question> fetchQuestion() async {
    print("Fetching question...");
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/questions/random')
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      print(decoded);
      question = Question(
        id: decoded['id'],
        questionText: decoded['question_text'],
        options: <String, String>{
          'A': decoded['option_a'],
          'B': decoded['option_b'],
          'C': decoded['option_c'],
          'D': decoded['option_d'],
        },
        answer: decoded['correct_option']
      );
      return question;
    } else {
      print("Failed to fetch question");
      question = Question(
        id: 0,
        questionText: "Error",
        options: <String, String>{
          'A': "Error",
          'B': "Error",
          'C': "Error",
          'D': "Error",
        },
        answer: "A"
      );
      return question;
    }
  }
}
