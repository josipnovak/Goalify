import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/triviaviewmodel.dart';
import 'package:mobile/models/question.dart';

class TriviaScreen extends StatefulWidget {
  final TriviaViewModel viewModel;

  const TriviaScreen({super.key, required this.viewModel});
  
  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  Question? currentQuestion;
  bool? isCorrect; 
  int points = 0;

  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchQuestion().then((question) {
      setState(() {
        currentQuestion = question;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: currentQuestion == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Points: $points'),
                  Text(
                    currentQuestion!.questionText,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: currentQuestion!.options.entries.map((entry) {
                      return ElevatedButton(
                        onPressed: isCorrect == null
                            ? () {
                              final result = widget.viewModel.isAnswerCorrect(currentQuestion!.id, entry.key);
                              setState(() {
                                isCorrect = result;
                                if (result) {
                                  points += 5;
                                }
                              });
                            }
                            : null,
                        child: Text(entry.value),
                      );
                    }).toList(),
                  ),
                  if (isCorrect != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            isCorrect! ? 'Correct!' : 'Incorrect!',
                            style: TextStyle(
                              fontSize: 20,
                              color: isCorrect! ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (isCorrect!)
                            ElevatedButton(
                              onPressed: () {
                                widget.viewModel.fetchQuestion().then((question) {
                                  setState(() {
                                    currentQuestion = question;
                                    isCorrect = null;
                                  });
                                });
                              },
                              child: Text('Next'),
                            )
                          else
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    widget.viewModel.fetchQuestion().then((question) {
                                      setState(() {
                                        currentQuestion = question;
                                        isCorrect = null;
                                      });
                                    });
                                  },
                                  child: Text('Try Again'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}