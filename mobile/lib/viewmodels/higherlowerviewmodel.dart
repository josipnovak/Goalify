import 'package:mobile/models/player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HigherLowerViewModel {
  late String title;
  late Player player1;
  late Player player2;

  HigherLowerViewModel() {
    title = 'Higher Lower';
    player1 = Player(id: 0, name: '', nationality: '', dateOfBirth: DateTime.now(), club: '', marketValue: 0);
    player2 = Player(id: 0, name: '', nationality: '', dateOfBirth: DateTime.now(), club: '', marketValue: 0);
  }

  Future<bool> fetchPlayer() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/higherlower/player/'),
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      print(decoded);
      player1 = Player(
        id: decoded['id'],
        name: decoded['name'],
        dateOfBirth: DateTime.parse(decoded['date_of_birth']),
        club: decoded['club'],
        marketValue: double.parse(decoded['market_value']),
        nationality: decoded['nationality']
      );
      return true;
    } 
    return false;
  }

  Future<bool> fetchSecondPlayer() async {
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/higherlower/player/'),
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      player2 = Player(
        id: decoded['id'],
        name: decoded['name'],
        dateOfBirth: DateTime.parse(decoded['date_of_birth']),
        club: decoded['club'],
        marketValue: double.parse(decoded['market_value']),
        nationality: decoded['nationality']
      );
      return true;
    } 
    return false;
  }

  Future<bool> checkAnswer(String higher) async {
    final response = await http.get(
      Uri.parse('http://192.168.0.3:8080/higherlower/check/${player1.id}/${player2.id}/$higher'),
    );
    if(response.statusCode == 200){
      var decoded = jsonDecode(response.body);
      return decoded['success'];
    }
    return false;
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