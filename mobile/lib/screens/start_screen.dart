import 'package:flutter/material.dart';
import 'package:mobile/screens/trivia.dart';
import 'package:mobile/screens/tictactoe.dart';
import 'package:mobile/screens/higher_lower.dart';

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
                  MaterialPageRoute(builder: (context) => const TriviaScreen(title: 'Trivia Game', startText: 'Start Trivia'))
                );
              },
              child: const Text('Trivia'),
            )),
            ButtonTheme(child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const TicTacToeScreen(title: 'Tic Tac Toe', startText: 'Start Tic Tac Toe'))
                );
              },
              child: const Text('TicTacToe'),
            )),
            ButtonTheme(child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const HigherLowerScreen(title: 'Higher Lower', startText: 'Start Higher Lower'))
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