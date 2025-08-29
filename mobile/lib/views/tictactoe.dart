import 'package:flutter/material.dart';
import 'package:mobile/viewmodels/tictactoeviewmodel.dart';
import 'package:mobile/models/player.dart';
import 'package:mobile/views/theme.dart';

class TicTacToeScreen extends StatefulWidget {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('Search Player for Cell', style: Theme.of(context).textTheme.headlineMedium),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type player name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) fetchPlayers(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isLoading) const CircularProgressIndicator(),
                  if (!isLoading && players.isEmpty && _controller.text.isNotEmpty)
                    Text('No players found', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.amber)),
                  if (players.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: players.map((player) => ListTile(
                          title: Text(player.name, style: Theme.of(context).textTheme.bodyLarge),
                          onTap: () async {
                            bool isCorrect = await widget.viewModel.checkPlayer(nation, clubId, player.id.toString());
                            Navigator.of(context).pop();
                            if (isCorrect) {
                              setState(() {
                                selectedPlayers['$nation-${clubId}'] = currentPlayer;
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
                  child: Text('Cancel', style: Theme.of(context).textTheme.bodyLarge),
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
                          Text(
                            widget.viewModel.title,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 24),
                          Table(
                            border: TableBorder.all(color: Colors.grey.shade300),
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  const SizedBox(),
                                  for (var club in widget.viewModel.game.clubs)
                                    Column(
                                      children: [
                                        Image.network(club.logoUrl, width: 48, height: 48),
                                        const SizedBox(height: 8),
                                        Text(club.name, style: Theme.of(context).textTheme.bodyMedium),
                                      ],
                                    ),
                                ],
                              ),
                              for (var nation in widget.viewModel.game.nations)
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(nation, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                    ),
                                    for (var club in widget.viewModel.game.clubs)
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: selectedPlayers['$nation-${club.id}'] == null
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  _showPlayerDialog(nation, club.id.toString());
                                                },
                                                child: const Text('Add'),
                                              )
                                            : Center(
                                                child: Text(
                                                  selectedPlayers['$nation-${club.id}']!,
                                                  style: Theme.of(context).textTheme.headlineMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                          if (winnerMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                winnerMessage!,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green),
                              ),
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