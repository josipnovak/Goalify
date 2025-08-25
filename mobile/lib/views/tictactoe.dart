import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/tictactoeviewmodel.dart';
import 'package:mobile/models/player.dart';

class TicTacToeScreen extends StatefulWidget{
  final TicTacToeViewModel viewModel;

  const TicTacToeScreen({super.key, required this.viewModel});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  bool created = false;
  String currentPlayer = 'X';
  Map<String, String> selectedPlayers = {};
  String? winnerMessage;

  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchGame().then((created) {
      setState(() {
        this.created = created;
      });
    });
  }

  void _showPlayerDialog(String nation, String clubId) {
    TextEditingController _controller = TextEditingController();
    List<Player> players = [];
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> fetchPlayers(String query) async {
              setStateDialog(() => isLoading = true);
              players = await widget.viewModel.fetchPlayers(query);
              setStateDialog(() => isLoading = false);
            }

            return AlertDialog(
              title: Text('Search player for cell'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type player name'),
                    onChanged: (value) {
                      if (value.isNotEmpty) fetchPlayers(value);
                    },
                  ),
                  SizedBox(height: 10),
                  if (isLoading) CircularProgressIndicator(),
                  if (!isLoading && players.isEmpty && _controller.text.isNotEmpty)
                    Text('No players found', style: TextStyle(color: Colors.amber)),
                  if (players.isNotEmpty)
                    SizedBox(
                      height: 200, 
                      child: ListView(
                        children: players.map((player) => ListTile(
                          title: Text(player.name),
                          onTap: () async {
                            bool isCorrect = await widget.viewModel.checkPlayer(nation, clubId, player.id.toString());
                            Navigator.of(context).pop(); 
                            if (isCorrect) {
                              setState(() {
                                selectedPlayers['$nation-${clubId}'] = currentPlayer;
                                print("Selected players after update: $selectedPlayers");  
                                currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
                                winnerMessage = widget.viewModel.checkWinner(selectedPlayers);
                              });
                            } else {
                              setState(() {
                                currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Incorrect player selected')),
                              );
                            }
                          },
                        )).toList(),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
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
            Text(
              widget.viewModel.title,
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
                    for (var club in widget.viewModel.game.clubs)
                      Column(
                        children: [
                          Image.network(club.logoUrl, width: 40, height: 40),
                          Text(club.name, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                  ],
                ),
                for (var nation in widget.viewModel.game.nations)
                  TableRow(
                    children: [
                      Text(nation, style: TextStyle(fontWeight: FontWeight.bold)),
                      for (var club in widget.viewModel.game.clubs)
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: selectedPlayers['$nation-${club.id}'] == null
                              ? ElevatedButton(
                              onPressed: () {
                                print(selectedPlayers);
                                _showPlayerDialog(nation, club.id.toString());
                              },
                              child: Text('Add', style: TextStyle(fontSize: 12)),
                            ) : Center(
                              child: Text(
                                selectedPlayers['$nation-${club.id}']!,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        )
                    ],
                  ),
              ],
            ),
            if (winnerMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  winnerMessage!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}