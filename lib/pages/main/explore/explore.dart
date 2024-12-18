import 'package:app1/models/games.dart';
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
        filteredgames.isEmpty
            ? const Center(
                child: Text('Hasil tidak ditemukan'),
              )
            : Expanded(
              child: ListView.builder(
                itemCount: filteredgames.length,
                itemBuilder: (context, index) {
                  final game = filteredgames[index];
                  return Card(
                      elevation: 8,
                      margin: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: Expanded(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(8)),
                                          child: Image.network(
                                            game.thumbnail,
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Text(
                                          game.title,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade600,
                                                borderRadius: const BorderRadius.all(Radius.circular(4))
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                                child: Text(
                                                  game.genre,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4,),
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade600,
                                                borderRadius: const BorderRadius.all(Radius.circular(4))
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      game.platform == 'PC (Windows)' ? Icons.window : Icons.language,
                                                      color: Colors.black87,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4,),
                                                    Text(
                                                      game.platform,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          game.short_description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                        )
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
