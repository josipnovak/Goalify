import 'package:flutter/material.dart';
import 'package:mobile/models/question.dart';

class TriviaScreen extends StatefulWidget {
  final String title;

  final Question questionExample;

  const TriviaScreen({super.key, required this.title, required this.questionExample});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
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
              widget.questionExample.questionText,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Column(
              children: widget.questionExample.options.map((option) {
                return ElevatedButton(
                  onPressed: () {
                    print("Selected answer: $option");
                  },
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}