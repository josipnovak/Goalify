import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/higherlowerviewmodel.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: created == false
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text(widget.viewModel.player1.name),
                      Text(widget.viewModel.player1.nationality),
                      Text('Age: ${widget.viewModel.calculateAge(widget.viewModel.player1.dateOfBirth)}'),
                      Text(widget.viewModel.player1.club),
                      Text(widget.viewModel.player1.marketValue.toString()),
                      started == false && correctAnswer != false
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () {
                                widget.viewModel.fetchSecondPlayer().then((started) {
                                  setState(() {
                                    this.started = started;
                                  });
                            });
                          },
                          child: Text('Start'),
                        ),
                        )
                        : Column(
                          children: [
                            correctAnswer != false 
                            ?
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
                                child: Text('Lower'),
                              ),
                              SizedBox(width: 20),
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
                                child: Text('Higher'),
                              ),
                            ],
                          )
                          : Text("Wrong answer"),
                        SizedBox(height: 50),
                        Column(
                          children: [
                            Text(widget.viewModel.player2.name),
                            Text(widget.viewModel.player2.nationality),
                            Text('Age: ${widget.viewModel.calculateAge(widget.viewModel.player2.dateOfBirth)}'),
                            correctAnswer == false ? 
                              Center(
                                child: Column(
                                  children: [
                                    Text(widget.viewModel.player2.club),
                                    Text(widget.viewModel.player2.marketValue.toString()),
                                  ],
                                ),
                              )
                            : Text(widget.viewModel.player2.club),
                            
                          ],
                        ),
                        ],
                      ),
                    ],
                  ),
                ],
                ),
              ),
            );
    }
}