import 'package:flutter/material.dart';

class TicTacToeScreen extends StatefulWidget{
  final String title;
  final String startText;

  const TicTacToeScreen({super.key, required this.title, required this.startText});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Starting Tic Tac Toe...");
              },
              child: Text(widget.startText),
            ),
          ],
        ),
      ),
    );
  }
}