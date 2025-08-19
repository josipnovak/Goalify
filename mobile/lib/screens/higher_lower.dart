import 'package:flutter/material.dart';
import 'package:mobile/models/player.dart';

class HigherLowerScreen extends StatefulWidget {
  final String title;
  final Player player1;
  final Player player2;

  int calculateAge(DateTime birthDate){
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  const HigherLowerScreen({super.key, required this.title, required this.player1, required this.player2});

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
            Column(
              children: [
                Text(widget.player1.name),
                Text(widget.player1.nationality),
                Text('Age: ${widget.calculateAge(widget.player1.dateOfBirth)}'),
                Text(widget.player1.marketValue.toString()),
                Text(widget.player1.club),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Lower button pressed");
                  },
                  child: Text('Lower'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    print("Higher button pressed");
                  },
                  child: Text('Higher'),
                ),
              ],
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Text(widget.player2.name),
                Text(widget.player2.nationality),
                Text('Age: ${widget.calculateAge(widget.player2.dateOfBirth)}'),
                Text(widget.player2.marketValue.toString()),
                Text(widget.player2.club),
              ],
            ),
          ],
        ),
      ),
    );
  }
}