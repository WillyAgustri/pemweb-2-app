import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Games {
  final int id;
  final String title;
  final String thumbnail;
  final String short_description;
  final String game_url;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String release_date;
  final String freetogame_profile_url;

  Games({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.short_description,
    required this.game_url,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.release_date,
    required this.freetogame_profile_url,
  });

  factory Games.fromJson(Map<String, dynamic> json) {
    return Games(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      short_description: json['short_description'],
      game_url: json['game_url'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      release_date: json['release_date'],
      freetogame_profile_url: json['freetogame_profile_url'],
    );
  }
}

String freegameurl = 'https://free-to-play-games-database.p.rapidapi.com';
String? freegamesKey = dotenv.env['FREEGAMES_KEY'];

Future<List<Games>> loadGames() async {
  final url = Uri.parse('$freegameurl/api/games');

  final response = await http.get(url, headers: {
    'x-rapidapi-key': freegamesKey!,
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonResult = jsonDecode(response.body);
    return jsonResult.map((item) => Games.fromJson(item)).toList();
  } else {
    throw Exception('failed to load game data');
  }
}

Future<List<Games>> loadPopularGames() async {
  final url = Uri.parse('$freegameurl/api/games?sort-by=popularity');

  final response = await http.get(url, headers: {
    'x-rapidapi-key': freegamesKey!,
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonResult = jsonDecode(response.body);
    return jsonResult
      .map((item) => Games.fromJson(item))
      .toList();
  } else {
    throw Exception('failed to load game data');
  }
}

Future<List<Games>> loadNewestGames() async {
  final url =
      Uri.parse('$freegameurl/api/games?sort-by=release-date');

  final response = await http.get(url, headers: {
    'x-rapidapi-key': freegamesKey!,
  });

  if (response.statusCode == 200) {
    final List<dynamic> jsonResult = jsonDecode(response.body);
    return jsonResult
        .map((item) => Games.fromJson(item))
        .toList()
        .take(6)
        .toList();
  } else {
    throw Exception('failed to load game data');
  }
}
