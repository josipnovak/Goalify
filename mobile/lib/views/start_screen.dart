import 'package:flutter/material.dart';
import 'package:mobile/views/theme.dart';
import 'package:mobile/views/trivia.dart';
import 'package:mobile/views/tictactoe.dart';
import 'package:mobile/views/higher_lower.dart';
import 'package:mobile/viewmodels/triviaviewmodel.dart';
import 'package:mobile/viewmodels/tictactoeviewmodel.dart';
import 'package:mobile/viewmodels/higherlowerviewmodel.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.title});

  final String title;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Choose a Game',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TriviaScreen(viewModel: TriviaViewModel())),
                      );
                    },
                    child: const Text('Trivia'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TicTacToeScreen(viewModel: TicTacToeViewModel())),
                      );
                    },
                    child: const Text('Tic Tac Toe'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HigherLowerScreen(viewModel: HigherLowerViewModel())),
                      );
                    },
                    child: const Text('Higher or Lower'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}