import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/higherlowerviewmodel.dart';
import 'package:mobile/views/theme.dart';

class HigherLowerScreen extends StatefulWidget {
  final HigherLowerViewModel viewModel;

  const HigherLowerScreen({super.key, required this.viewModel});

  @override
  State<HigherLowerScreen> createState() => _HigherLowerScreenState();
}

class _HigherLowerScreenState extends State<HigherLowerScreen> {
  bool created = false;
  bool started = false;
  bool? correctAnswer;

  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchPlayer().then((created) {
      setState(() {
        this.created = created;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.viewModel.title),
        ),
        body: created == false
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.viewModel.player1.name, style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 8),
                          Text(widget.viewModel.player1.nationality, style: Theme.of(context).textTheme.bodyLarge),
                          Text('Age: ${widget.viewModel.calculateAge(widget.viewModel.player1.dateOfBirth)}',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text(widget.viewModel.player1.club, style: Theme.of(context).textTheme.bodyLarge),
                          Text(widget.viewModel.player1.marketValue.toString(), style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 24),
                          if (started == false && correctAnswer != false)
                            ElevatedButton(
                              onPressed: () {
                                widget.viewModel.fetchSecondPlayer().then((started) {
                                  setState(() {
                                    this.started = started;
                                  });
                                });
                              },
                              child: const Text('Start'),
                            )
                          else
                            Column(
                              children: [
                                if (correctAnswer != false)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool correct = await widget.viewModel.checkAnswer('false');
                                          if (correct) {
                                            setState(() {
                                              widget.viewModel.player1 = widget.viewModel.player2;
                                            });
                                            await widget.viewModel.fetchSecondPlayer();
                                            setState(() {});
                                          } else {
                                            setState(() {
                                              correctAnswer = false;
                                            });
                                          }
                                        },
                                        child: const Text('Lower'),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool correct = await widget.viewModel.checkAnswer('true');
                                          if (correct) {
                                            setState(() {
                                              widget.viewModel.player1 = widget.viewModel.player2;
                                            });
                                            await widget.viewModel.fetchSecondPlayer();
                                            setState(() {});
                                          } else {
                                            setState(() {
                                              correctAnswer = false;
                                            });
                                          }
                                        },
                                        child: const Text('Higher'),
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    'Wrong answer',
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.red),
                                  ),
                                const SizedBox(height: 32),
                                Column(
                                  children: [
                                    Text(widget.viewModel.player2.name, style: Theme.of(context).textTheme.headlineLarge),
                                    Text(widget.viewModel.player2.nationality, style: Theme.of(context).textTheme.bodyLarge),
                                    Text(
                                        'Age: ${widget.viewModel.calculateAge(widget.viewModel.player2.dateOfBirth)}',
                                        style: Theme.of(context).textTheme.bodyMedium),
                                    Text(widget.viewModel.player2.club, style: Theme.of(context).textTheme.bodyLarge),
                                    if (correctAnswer == false)
                                      Column(
                                        children: [
                                          Text(widget.viewModel.player2.marketValue.toString(),
                                              style: Theme.of(context).textTheme.bodyLarge),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}