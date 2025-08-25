import 'package:mobile/models/player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HigherLowerViewModel {
  late String title;
  late Player player1;
  late Player player2;

  HigherLowerViewModel() {
    title = 'Higher Lower';
  }

  Future<Player> fetchPlayer() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/higherlower/player/'),
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      player1 = decoded.map((data) => Player(
        id: data['id'],
        name: data['name'],
        nationality: data['nationality'],
        dateOfBirth: DateTime.parse(data['date_of_birth']),
        club: data['club'],
        marketValue: double.parse(data['market_value']),
      )).toList();
      return player1;
    } else {
      throw Exception('Failed to load player');
    }
  }

  int calculateAge(DateTime birthDate){
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}