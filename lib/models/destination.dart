import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Destination {
  final int id;
  final String name;
  final String description;
  final String address;
  final double longitude;
  final double latitude;
  final int like;
  final String image;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.like,
    required this.image,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      like: json['like'],
      image: json['image'],
    );
  }
}

Future<List<Destination>> loadDestinations() async {
  final data = await rootBundle.loadString('assets/tourism.json');
  final jsonResult = json.decode(data);
  return (jsonResult['destinations'] as List)
      .map((item) => Destination.fromJson(item))
      .toList();
}
