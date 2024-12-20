import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_games/models/detail_games.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailsPage extends StatefulWidget {
  final int? id;

  const GameDetailsPage({super.key, required this.id});

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  int currentPage = 0;
  Timer? timer;

  PageController pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 3) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  String formatDate(String dateStr) {
    DateTime parsedDate = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game Tidak Ditemukan')),
        body: const Center(child: Text('ID Game Tidak Valid')),
      );
    }

    return FutureBuilder<DetailGames>(
      future: loadDetailGame(widget.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('Error loading game details')));
        }

        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('No game data available')));
        }

        final game = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => context.pop()),
            title: Text(game.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: game.screenshots.length,
                    itemBuilder: (context, index) {
                      final screenshot = game.screenshots[index];
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.grey.shade800,
                          ),
                          Image.network(
                            screenshot.image,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Container(
                                color: Colors.grey.shade800,
                                width: double.infinity,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade800,
                                width: double.infinity,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: _getGenreColor(game.genre),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                game.genre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                                color: game.platform == 'PC (Windows)'
                                    ? Colors.blue
                                    : Colors.green,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    game.platform == 'PC (Windows)'
                                        ? Icons.window
                                        : Icons.language,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    game.platform,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tentang Game',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text(
                          'Penerbit: ${game.publisher}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Pengembang: ${game.developer}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Tanggal Rilis: ${formatDate(game.releaseDate)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          game.shortDescription,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(game.gameUrl);

                              if (!await launchUrl(url,
                                  mode: LaunchMode.inAppBrowserView)) {
                                throw Exception("Could not launch $url");
                              }
                            },
                            style: const ButtonStyle(
                              padding:
                                  WidgetStatePropertyAll(EdgeInsets.all(8)),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.white12),
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.blue),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Lihat Toko',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.shopping_bag,
                                  size: 16,
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Text(
                          game.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                game.minimumSystemRequirements != null
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Persyaratan Minimum',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Divider(),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Sistem Operasi (OS): ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: game.minimumSystemRequirements
                                              ?.os ??
                                          'N/A',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Prosesor: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: game.minimumSystemRequirements
                                              ?.processor ??
                                          'N/A',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Memori (RAM): ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: game.minimumSystemRequirements
                                              ?.memory ??
                                          'N/A',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Grafik: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: game.minimumSystemRequirements
                                              ?.graphics ??
                                          'N/A',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Penyimpanan: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: game.minimumSystemRequirements
                                              ?.storage ??
                                          'N/A',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getGenreColor(String genre) {
    switch (genre) {
      case 'MMORPG':
      case 'MMO':
      case 'Action RPG':
        return Colors.red;
      case 'Shooter':
      case 'MMOFPS':
      case 'Battle Royale':
      case 'Strategy':
        return Colors.orange;
      case 'MOBA':
        return Colors.orangeAccent;
      case 'Sports':
        return Colors.greenAccent.shade400;
      case 'Racing':
        return Colors.purple.shade800;
      default:
        return Colors.blueAccent.shade400;
    }
  }
}
