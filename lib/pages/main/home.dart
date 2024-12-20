import 'dart:async';
import 'package:infinite_games/models/games.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Games> games = [];
  List<Games> newestGames = [];
  List<Games> cachedGames = [];
  List<Games> cachedNewestGames = [];
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
    if (cachedGames.isEmpty) {
      cachedGames = await loadPopularGames();
    }

    if (cachedNewestGames.isEmpty) {
      cachedNewestGames = await loadNewestGames();
    }

    setState(() {
      games = cachedGames.take(25).toList();
      newestGames = cachedNewestGames;
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

    String formatDate(String dateStr) {
      DateTime parsedDate = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    return Scaffold(
      body: games.isEmpty || newestGames.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/hero.png'),
                  // const SizedBox(height: 16,),
                  Container(
                      color: const Color.fromRGBO(25, 28, 85, 1),
                      width: double.infinity,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Game Rilisan Terbaru',
                          style: TextStyle(
                            fontFamily: '',
                            color: Colors.white,
                            fontSize: 24,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: newestGames.length,
                      itemBuilder: (context, index) {
                        final game = newestGames[index];
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: double.minPositive,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                repeat: ImageRepeat.noRepeat,
                                opacity: 0.33,
                                image: NetworkImage(game.thumbnail)),
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
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                      child: DecoratedBox(
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        178,
                                                                        0,
                                                                        0,
                                                                        0)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      8),
                                                          child: Text(
                                                            'Rilis pada ${formatDate(game.release_date)}',
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    )
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
                                              Text(
                                                'Oleh ${game.publisher}',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
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
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          context.push(
                                                              '/game-detail?id=${game.id}');
                                                        },
                                                        style:
                                                            const ButtonStyle(
                                                          padding:
                                                              WidgetStatePropertyAll(
                                                                  EdgeInsets
                                                                      .all(8)),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors
                                                                      .white12),
                                                          foregroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.blue),
                                                        ),
                                                        child: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Lihat Detail',
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward,
                                                              size: 18,
                                                            )
                                                          ],
                                                        )),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          final Uri url =
                                                              Uri.parse(game
                                                                  .game_url);

                                                          if (!await launchUrl(
                                                              url,
                                                              mode: LaunchMode
                                                                  .inAppBrowserView)) {
                                                            throw Exception(
                                                                "Could not launch $url");
                                                          }
                                                        },
                                                        style:
                                                            const ButtonStyle(
                                                          padding:
                                                              WidgetStatePropertyAll(
                                                                  EdgeInsets
                                                                      .all(8)),
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors
                                                                      .white12),
                                                          foregroundColor:
                                                              WidgetStatePropertyAll(
                                                                  Colors.blue),
                                                        ),
                                                        child: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Lihat Toko',
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .shopping_bag,
                                                              size: 16,
                                                            )
                                                          ],
                                                        )),
                                                  )
                                                ],
                                              )
                                            ])),
                                  ])),
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
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'Game Populer',
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
                      return Card(
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
                                                  color: Colors.grey.shade800,
                                                ),
                                                Image.network(
                                                  game.thumbnail,
                                                  width: double.infinity,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Container(
                                                      color:
                                                          Colors.grey.shade800,
                                                      width: double.infinity,
                                                      height: 150,
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color:
                                                          Colors.grey.shade800,
                                                      width: double.infinity,
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Oleh ${game.publisher}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
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
                                                        : game
                                                                        .genre ==
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
                                                                            .purple
                                                                            .shade800
                                                                        : Colors
                                                                            .blueAccent
                                                                            .shade400,
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
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        const BorderRadius.all(
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
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
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      context.push(
                                                          '/game-detail?id=${game.id}');
                                                    },
                                                    style: const ButtonStyle(
                                                      padding:
                                                          WidgetStatePropertyAll(
                                                              EdgeInsets.all(
                                                                  8)),
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.white12),
                                                      foregroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.blue),
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Lihat Detail',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_forward,
                                                          size: 18,
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      final Uri url = Uri.parse(
                                                          game.game_url);

                                                      if (!await launchUrl(url,
                                                          mode: LaunchMode
                                                              .inAppBrowserView)) {
                                                        throw Exception(
                                                            "Could not launch $url");
                                                      }
                                                    },
                                                    style: const ButtonStyle(
                                                      padding:
                                                          WidgetStatePropertyAll(
                                                              EdgeInsets.all(
                                                                  8)),
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.white12),
                                                      foregroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.blue),
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Lihat Toko',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Icon(
                                                          Icons.shopping_bag,
                                                          size: 16,
                                                        )
                                                      ],
                                                    )),
                                              )
                                            ],
                                          )
                                        ])),
                              ]));
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
