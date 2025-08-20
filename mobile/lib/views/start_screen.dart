import 'package:flutter/material.dart';
import 'package:mobile/views/trivia.dart';
import 'package:mobile/views/tictactoe.dart';
import 'package:mobile/views/higher_lower.dart';
import 'package:mobile/viewmodels/triviaviewmodel.dart';
import 'package:mobile/models/tictactoe.dart';
import 'package:mobile/models/club.dart';
import 'package:mobile/models/player.dart';


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
                  MaterialPageRoute(builder: (context) => HigherLowerScreen(title: 'Higher Lower', 
                  player1: Player(id: 1, name: 'Lionel Messi', dateOfBirth: DateTime(1987, 6, 24), nationality: 'Argentinian', marketValue: 100.0, club: 'Barcelona'), 
                  player2: Player(id: 2, name: 'Cristiano Ronaldo', dateOfBirth: DateTime(1985, 2, 5), nationality: 'Portuguese', marketValue: 90.0, club: 'Real Madrid')))
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