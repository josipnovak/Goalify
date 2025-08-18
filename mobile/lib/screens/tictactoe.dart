import 'package:flutter/material.dart';
import 'package:mobile/models/tictactoe.dart';

class TicTacToeScreen extends StatefulWidget{
  final String title;
  final TicTacToe game;

  const TicTacToeScreen({super.key, required this.title, required this.game});

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
            Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    SizedBox(), 
                    for (var club in widget.game.clubs)
                      Column(
                        children: [
                          Image.network(club.logoUrl, width: 40, height: 40),
                          Text(club.name, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                  ],
                ),
                for (var nation in widget.game.nations)
                  TableRow(
                    children: [
                      Text(nation, style: TextStyle(fontWeight: FontWeight.bold)),
                      for (var club in widget.game.clubs)
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              print("Selected ${club.name} from $nation");
                            },
                            child: Text('0', style: TextStyle(fontSize: 24)),
                          ),
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