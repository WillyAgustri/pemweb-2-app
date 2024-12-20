import 'package:flutter/material.dart';
import 'package:infinite_games/models/games_on_sales.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<SalesGames> games = [];

  @override
  void initState() {
    super.initState();
    loadGamesOnSalesToPage();
  }

  Future<void> loadGamesOnSalesToPage() async {
    final loadedGames = await loadGamesOnSales();
    final gameItem = loadedGames.where((g) => g.type == 'game').toList();
    setState(() {
      games = gameItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatPrice(int number) {
      final NumberFormat formatter = NumberFormat("#,##0", "id_ID");
      return formatter.format(number);
    }

    String formatDate(String dateStr) {
      DateTime parsedDate = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    return Scaffold(
      body: games.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          game.image != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 150,
                                        color: Colors.grey.shade800,
                                      ),
                                      Image.network(
                                        game.image!,
                                        width: double.infinity,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            color: Colors.grey.shade800,
                                            width: double.infinity,
                                            height: 150,
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade800,
                                            width: double.infinity,
                                            height: 150,
                                          );
                                        },
                                      ),
                                      game.expiry != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                      bottomRight:
                                                          Radius.circular(8)),
                                              child: DecoratedBox(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromARGB(178, 0, 0, 0)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                  child: Text(
                                                    'Promo hingga ${formatDate(game.expiry!)}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                )
                              : DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[300]),
                                ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            game.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen[900],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Text(
                                    '-${game.discount.toString()}%',
                                    style: const TextStyle(
                                        color: Colors.lightGreenAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  color: Colors.white12,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text(
                                      'Rp.${formatPrice(game.regularPrice)}',
                                      style: const TextStyle(
                                          color: Colors.white30,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  )),
                              DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                    child: Text(
                                      game.dealPrice != 0
                                          ? 'Rp.${formatPrice(game.dealPrice)}'
                                          : 'Gratis',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  final Uri url = Uri.parse(game.url!);

                                  if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
                                    throw Exception("Could not launch $url");
                                  }
                                },
                                style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                                  backgroundColor: WidgetStatePropertyAll(Colors.white12),
                                  foregroundColor: WidgetStatePropertyAll(Colors.blue),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Lihat Toko', style: TextStyle(fontSize: 14),),
                                    SizedBox(width: 8,),
                                    Icon(
                                      Icons.shopping_bag,
                                      size: 16,
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ));
              }),
    );
  }
}
