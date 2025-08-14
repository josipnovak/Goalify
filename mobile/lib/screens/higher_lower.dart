import 'package:flutter/material.dart';

class HigherLowerScreen extends StatefulWidget {
  final String title;
  final String startText;

  const HigherLowerScreen({super.key, required this.title, required this.startText});

  @override
  State<HigherLowerScreen> createState() => _HigherLowerScreenState();
}

class _HigherLowerScreenState extends State<HigherLowerScreen> {
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
                print("Starting Higher Lower...");
              },
              child: Text(widget.startText),
            ),
          ],
        ),
      ),
    );
  }
}