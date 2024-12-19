import 'package:http/http.dart' as http;
import 'dart:convert';

class SalesGames {
  final String title;
  final String? type;
  final String? image;
  // final List<String> platforms;
  final int regularPrice;
  final int dealPrice;
  final int discount;
  final String? expiry;
  final String? url;

  SalesGames({
    required this.title,
    required this.type,
    required this.image,
    // required this.platforms,
    required this.regularPrice,
    required this.dealPrice,
    required this.discount,
    required this.expiry,
    required this.url,
  });

  factory SalesGames.fromJson(Map<String, dynamic> json) {
    return SalesGames(
      title: json['title'],
      type: json['type'],
      image: json['assets']['banner400'],
      // platforms: (json['deal']['platforms'] as List)
      //     .map((platform) => platform['name'] as String)
      //     .toList(),
      regularPrice: json['deal']['regular']['amount'],
      dealPrice: json['deal']['price']['amount'],
      discount: json['deal']['cut'],
      expiry: json['deal']['expiry'],
      url: json['deal']['url'],
    );
  }
}

Future<List<SalesGames>> loadGamesOnSales() async {
  final url = Uri.parse('https://api.isthereanydeal.com/deals/v2?key=3b118f8b6d1f715098489606e24b88931042fe68&country=ID&filter=N4IgxgrgLiBcoFsCWA7OBOADAGhAghgB5wCMmmAvhUA=&sort=-trending');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResult = jsonDecode(response.body);
      final List<dynamic> gamesOnSalesList = jsonResult['list'];

      return gamesOnSalesList.map((item) => SalesGames.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load games');
    }
  } catch (e) {
    throw Exception('Error fetching games: $e');
  }
}