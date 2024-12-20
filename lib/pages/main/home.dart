import 'dart:async';
import 'package:infinite_games/models/games.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Games> games = [];
  List<Games> newestGames = [];
  int currentPage = 0;
  Timer? timer;

  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    loadGamesToPage();

    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < 5) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Future<void> loadGamesToPage() async {
    if (games.isNotEmpty && newestGames.isNotEmpty) {
      return;
    }

    final loadedGames = await loadGames();
    final loadedNewestGames = await loadNewestGames();
    setState(() {
      games = loadedGames;
      newestGames = loadedNewestGames;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.settings.name != '/login') {
          context.go('/login');
        }
      });
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: games.isEmpty || newestGames.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Rilisan Terbaru',
                          style: TextStyle(
                            fontFamily: '',
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  Container(
                    color: Colors.black,
                    height: 325,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: newestGames.length,
                      itemBuilder: (context, index) {
                        final game = newestGames[index];
                        return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).go(
                              '/game-detail?id=${game.id}&title=${Uri.encodeComponent(game.title)}',
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: double.minPositive,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                repeat: ImageRepeat.noRepeat,
                                opacity: 0.33,
                                image: NetworkImage(game.thumbnail),
                              ),
                            ),
                            child: Card(
                              elevation: 8,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
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
                                                game.thumbnail,
                                                width: double.infinity,
                                                height: 150,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Container(
                                                    color: Colors.grey.shade800,
                                                    width: double.infinity,
                                                    height: 150,
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    color: Colors.grey.shade800,
                                                    width: double.infinity,
                                                    height: 150,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          game.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            // Genre and platform badges here
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          game.short_description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Text(
                          'Semua Game',
                          style: TextStyle(
                            fontFamily: '',
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).go(
                              '/game-detail?id=${game.id}&title=${Uri.encodeComponent(game.title)}',
                            );
                          },
                          child: Card(
                              elevation: 8,
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      height: 150,
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                    Image.network(
                                                      game.thumbnail,
                                                      width: double.infinity,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Container(
                                                          color: Colors
                                                              .grey.shade800,
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                        );
                                                      },
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                          color: Colors
                                                              .grey.shade800,
                                                          width:
                                                              double.infinity,
                                                          height: 150,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                game.title,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color: game.genre ==
                                                                    'MMORPG' ||
                                                                game.genre ==
                                                                    'MMO' ||
                                                                game.genre ==
                                                                    'Action RPG'
                                                            ? Colors.red
                                                            : game.genre ==
                                                                        'Shooter' ||
                                                                    game.genre ==
                                                                        'MMOFPS' ||
                                                                    game.genre ==
                                                                        'Battle Royale' ||
                                                                    game.genre ==
                                                                        'Strategy'
                                                                ? Colors.orange
                                                                : game.genre ==
                                                                        'MOBA'
                                                                    ? Colors
                                                                        .orangeAccent
                                                                    : game.genre ==
                                                                            'Sports'
                                                                        ? Colors
                                                                            .greenAccent
                                                                            .shade400
                                                                        : game.genre ==
                                                                                'Racing'
                                                                            ? Colors
                                                                                .purple.shade800
                                                                            : Colors
                                                                                .blueAccent.shade400,
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                                Radius.circular(
                                                                    4))),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 6),
                                                      child: Text(
                                                        game.genre,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        color: game.platform ==
                                                                'PC (Windows)'
                                                            ? Colors.blue
                                                            : Colors.green,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    4))),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 6),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            game.platform ==
                                                                    'PC (Windows)'
                                                                ? Icons.window
                                                                : Icons
                                                                    .language,
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
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                game.short_description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ])),
                                  ])));
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
