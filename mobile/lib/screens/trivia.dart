import 'package:flutter/material.dart';

class TriviaScreen extends StatefulWidget {
  final String title;
  final String startText;

  const TriviaScreen({super.key, required this.title, required this.startText});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Game'),
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
                print("Starting quiz...");
              },
              child: Text(widget.startText),
            ),
          ],
        ),
      ),
    );
  }
}