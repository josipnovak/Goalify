import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/triviaviewmodel.dart';
import 'package:mobile/models/question.dart';

class TriviaScreen extends StatefulWidget {
  final TriviaViewModel viewModel;

  const TriviaScreen({super.key, required this.viewModel});
  
  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchQuestion(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<Question>(
        future: widget.viewModel.fetchQuestion(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); 
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final question = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    question.questionText,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: question.options.entries.map((entry) {
                      return ElevatedButton(
                        onPressed: () {
                          print("Answer selected: ${entry.key}");
                        },
                        child: Text(entry.value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
