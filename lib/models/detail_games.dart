import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MinimumSystemRequirements {
  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

  MinimumSystemRequirements({
    required this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });

  factory MinimumSystemRequirements.fromJson(Map<String, dynamic> json) {
    return MinimumSystemRequirements(
      os: json['os'],
      processor: json['processor'],
      memory: json['memory'],
      graphics: json['graphics'],
      storage: json['storage'],
    );
  }
}

class Screenshot {
  final int id;
  final String image;

  Screenshot({
    required this.id,
    required this.image,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }
}
class DetailGames {
  final int id;
  final String title;
  final String status;
  final String shortDescription;
  final String description;
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final String freetogameProfileUrl;
  final MinimumSystemRequirements? minimumSystemRequirements;
  final List<Screenshot> screenshots;

  DetailGames({
    required this.id,
    required this.title,
    required this.status,
    required this.shortDescription,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    required this.freetogameProfileUrl,
    required this.minimumSystemRequirements,
    required this.screenshots,
  });

  factory DetailGames.fromJson(Map<String, dynamic> json) {
    final List<Screenshot> screenshots = (json['screenshots'] as List)
        .map((screenshot) => Screenshot.fromJson(screenshot)).take(3)
        .toList();

    screenshots.insert(0, Screenshot(id: 0, image: json['thumbnail']));

    return DetailGames(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      shortDescription: json['short_description'],
      description: json['description'],
      gameUrl: json['game_url'],
      genre: json['genre'],
      platform: json['platform'],
      publisher: json['publisher'],
      developer: json['developer'],
      releaseDate: json['release_date'],
      freetogameProfileUrl: json['freetogame_profile_url'],
      minimumSystemRequirements:  json['minimum_system_requirements'] != null
        ? MinimumSystemRequirements.fromJson(json['minimum_system_requirements'])
        : null,
      screenshots: screenshots,
    );
  }
}
String freegameurl = 'https://free-to-play-games-database.p.rapidapi.com';
String? freegamesKey = dotenv.env['FREEGAMES_KEY'];

Future<DetailGames> loadDetailGame(int id) async {
  final url = Uri.parse('$freegameurl/api/game?id=$id');

  final response = await http.get(url, headers: {'x-rapidapi-key': freegamesKey!});

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResult = jsonDecode(response.body);
    return DetailGames.fromJson(jsonResult);
  } else {
    throw Exception('Failed to load game details');
  }
}
