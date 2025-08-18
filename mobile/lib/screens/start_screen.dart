import 'package:flutter/material.dart';
import 'package:mobile/screens/trivia.dart';
import 'package:mobile/screens/tictactoe.dart';
import 'package:mobile/screens/higher_lower.dart';
import 'package:mobile/models/question.dart';
import 'package:mobile/models/tictactoe.dart';
import 'package:mobile/models/club.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.title});

  final String title;


  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => TriviaScreen(title: 'Trivia Game', questionExample: Question(questionText: 'Example Question?', options: const ['Option 1', 'Option 2', 'Option 3'], answer: 'Option 1')))
                );
              },
              child: const Text('Trivia'),
            )),
            ButtonTheme(child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => TicTacToeScreen(title: 'Tic Tac Toe', game: TicTacToe(clubs: [
                    Club(id: 59, name: 'Barcelona', logoUrl: 'https://crests.football-data.org/81.png'),
                    Club(id: 72, name: 'Real Madrid', logoUrl: 'https://crests.football-data.org/86.png'),
                    Club(id: 76, name: 'Atletico Madrid', logoUrl: 'https://crests.football-data.org/78.png'),
                  ], nations: [
                    'Spain',
                    'England',
                    'Italy',
                  ])))
                );
              },
              child: const Text('TicTacToe'),
            )),
            ButtonTheme(child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const HigherLowerScreen(title: 'Higher Lower'))
                );
              },
              child: const Text('HigherLower'),
            )),
          ],
        ),
      ),
    );
  }
}