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

  Future<TicTacToe> fetchGame() async {
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
      return game;
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
}