import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/triviaviewmodel.dart';
import 'package:mobile/models/question.dart';
import 'package:mobile/views/theme.dart';

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
    return Theme(
      data: appTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.viewModel.title),
        ),
        body: currentQuestion == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Points: $points', style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          Text(
                            currentQuestion!.questionText,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Column(
                            children: currentQuestion!.options.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
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
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isCorrect == null
                                        ? null
                                        : currentQuestion!.answer == entry.key
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
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
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: isCorrect! ? Colors.green : Colors.red,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
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
                                      child: const Text('Next'),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () {
                                        widget.viewModel.fetchQuestion().then((question) {
                                          setState(() {
                                            currentQuestion = question;
                                            isCorrect = null;
                                            points = 0;
                                          });
                                        });
                                      },
                                      child: const Text('Try Again'),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}