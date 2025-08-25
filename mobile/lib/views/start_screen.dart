import 'package:flutter/material.dart';
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
                  MaterialPageRoute(builder: (context) => TriviaScreen(viewModel: TriviaViewModel()))
                );
              },
              child: const Text('Trivia'),
            )),
            ButtonTheme(child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => TicTacToeScreen(viewModel: TicTacToeViewModel()))
                );
              },
              child: const Text('TicTacToe'),
            )),
            ButtonTheme(child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => HigherLowerScreen(viewModel: HigherLowerViewModel()))
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