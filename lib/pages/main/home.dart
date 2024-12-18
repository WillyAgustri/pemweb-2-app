import 'package:app1/models/games.dart';
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

  @override
  void initState() {
    super.initState();
    loadGamesToPage();
  }

  Future<void> loadGamesToPage() async {
    final loadedGames = await loadGames();
    setState(() {
      games = loadedGames;
    });
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
      body: games.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
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
    );
  }
}
