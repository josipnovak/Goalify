import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/higherlowerviewmodel.dart';

class HigherLowerScreen extends StatefulWidget {
  final HigherLowerViewModel viewModel;

  const HigherLowerScreen({super.key, required this.viewModel});

  @override
  State<HigherLowerScreen> createState() => _HigherLowerScreenState();
}

class _HigherLowerScreenState extends State<HigherLowerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(widget.viewModel.player1.name),
                Text(widget.viewModel.player1.nationality),
                Text('Age: ${widget.viewModel.calculateAge(widget.viewModel.player1.dateOfBirth)}'),
                Text(widget.viewModel.player1.marketValue.toString()),
                Text(widget.viewModel.player1.club),
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
                Text(widget.viewModel.player2.name),
                Text(widget.viewModel.player2.nationality),
                Text('Age: ${widget.viewModel.calculateAge(widget.viewModel.player2.dateOfBirth)}'),
                Text(widget.viewModel.player2.marketValue.toString()),
                Text(widget.viewModel.player2.club),
              ],
            ),
          ],
        ),
      ),
    );
  }
}