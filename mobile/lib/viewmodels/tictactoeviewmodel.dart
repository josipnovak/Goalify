import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/tictactoe.dart';
import 'package:mobile/models/club.dart';
import 'package:mobile/models/player.dart';

class TicTacToeViewModel{
  late String title;
  late TicTacToe game;

  TicTacToeViewModel(){
    title = "Tic Tac Toe";
    game = TicTacToe(clubs: [
      Club(id: 0, name: '', logoUrl: ''),
      Club(id: 0, name: '', logoUrl: ''),
      Club(id: 0, name: '', logoUrl: ''),
    ], nations: [
      '',
      '',
      '',
    ]);
  }

  Future<bool> fetchGame() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/generate/tictactoe/easy')
    );
    if(response.statusCode == 200){
      var decoded = jsonDecode(response.body);
      List<Club> clubs = [
        Club(id: decoded['teams'][0]['id'], name: decoded['teams'][0]['name'], logoUrl: decoded['teams'][0]['logo_url']),
        Club(id: decoded['teams'][1]['id'], name: decoded['teams'][1]['name'], logoUrl: decoded['teams'][1]['logo_url']),
        Club(id: decoded['teams'][2]['id'], name: decoded['teams'][2]['name'], logoUrl: decoded['teams'][2]['logo_url']),
      ];
      List<String> nations = List<String>.from(decoded['nationalities']);
      game = TicTacToe(clubs: clubs, nations: nations);
      return true;
    }
    throw Exception('Failed to load game');
  }

  Future<List<Player>> fetchPlayers(String query) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/players/?search=$query'),
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      List<Player> players = (decoded as List).map((data) => Player(
        id: data['id'],
        name: data['name'],
        dateOfBirth: DateTime.parse(data['date_of_birth']),
        club: '',
        nationality: data['nationality'],
        marketValue: double.parse(data['market_value']),
      )).toList();
      return players;
    }
    throw Exception('Failed to load players');
  }

  Future<bool> checkPlayer(String nationality, String clubId, String playerId) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/tictactoe/check/$nationality/$clubId/$playerId'),
    ); 
    if(response.statusCode == 200){
      var decoded = jsonDecode(response.body);
      print(decoded);
      return decoded['success'];
    }
    return false;
  }

  String? checkWinner(Map<String, String> selectedPlayers) {
    final size = game.clubs.length;
    List<List<String>> board = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) {
          String key = '${game.nations[i]}-${game.clubs[j].id}';
          String? val = selectedPlayers[key];
          if (val == 'X' || val == 'O') {
            return val!;
          }
          return ' ';
        },
      ),
    );

    for (int i = 0; i < size; i++) {
      String first = board[i][0];
      if (first != ' ' && board[i].every((sign) => sign == first)) {
        return 'Player $first wins!';
      }
    }
    for (int j = 0; j < size; j++) {
      String first = board[0][j];
      if (first != ' ' && List.generate(size, (i) => board[i][j]).every((sign) => sign == first)) {
        return 'Player $first wins!';
      }
    }
    String diag1 = board[0][0];
    if (diag1 != ' ' && List.generate(size, (i) => board[i][i]).every((sign) => sign == diag1)) {
      return 'Player $diag1 wins!';
    }
    String diag2 = board[0][size - 1];
    if (diag2 != ' ' && List.generate(size, (i) => board[i][size - 1 - i]).every((sign) => sign == diag2)) {
      return 'Player $diag2 wins!';
    }
    bool allFilled = board.expand((row) => row).every((sign) => sign == 'X' || sign == 'O');
    if (allFilled) {
      return "It's a draw!";
    }
    return null;
  }
}