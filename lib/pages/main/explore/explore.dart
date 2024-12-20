import 'package:infinite_games/models/games.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Games> games = [];
  List<Games> filteredgames = [];

  @override
  void initState() {
    super.initState();
    loadgamesToPage();
  }

  Future<void> loadgamesToPage() async {
    final loadedgames = await loadGames();
    setState(() {
      games = loadedgames;
      filteredgames = games;
    });
  }

  void _filteredgames(String query) {
    setState(() {
      filteredgames = games
          .where((g) => g.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari Game',
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  onChanged: _filteredgames),
            ),
            const SizedBox(
              height: 20,
            ),
            games.isEmpty
                ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                : filteredgames.isEmpty
                    ? Expanded(
                        flex: 1,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '404',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                              ),
                              Text(
                                'Hasil tidak ditemukan',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredgames.length,
                          itemBuilder: (context, index) {
                            final game = filteredgames[index];
                            return Card(
                                elevation: 8,
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Expanded(
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
                                                    child: Image.network(
                                                      game.thumbnail,
                                                      width: double.infinity,
                                                      height: 150,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8,),
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
                                                        decoration:
                                                            BoxDecoration(
                                                                color: game.genre == 'MMORPG' ||
                                                                        game.genre ==
                                                                            'MMO' ||
                                                                        game.genre ==
                                                                            'Action RPG'
                                                                    ? Colors.red
                                                                    : game.genre == 'Shooter' ||
                                                                            game.genre ==
                                                                                'MMOFPS' ||
                                                                            game.genre ==
                                                                                'Battle Royale' ||
                                                                            game.genre ==
                                                                                'Strategy'
                                                                        ? Colors
                                                                            .orange
                                                                        : game.genre ==
                                                                                'MOBA'
                                                                            ? Colors.orangeAccent
                                                                            : game.genre == 'Sports'
                                                                                ? Colors.greenAccent.shade400
                                                                                : game.genre == 'Racing'
                                                                                    ? Colors.purple.shade800
                                                                                    : Colors.blueAccent.shade400,
                                                                borderRadius: const BorderRadius.all(Radius.circular(4))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                            game.genre,
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
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                game.platform ==
                                                                        'PC (Windows)'
                                                                    ? Icons
                                                                        .window
                                                                    : Icons
                                                                        .language,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                game.platform,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
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
                                                  Text(game.short_description,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis)
                                                ]),
                                          )),
                                    ]));
                          },
                        ),
                      ),
          ],
        ));
  }
}
