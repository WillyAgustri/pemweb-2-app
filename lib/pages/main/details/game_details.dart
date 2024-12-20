import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/games.dart';

class GameDetailsPage extends StatelessWidget {
  // parameter untuk mengambil gameId;
  final int id;

// untuk route
  const GameDetailsPage({super.key, required this.id});

  Games? findGameByID(List<Games> games, int id) {
    try {
      return games.firstWhere((game) => game.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Games>>(
      future: loadGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading game details'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No game data available'));
        }

        final game = findGameByID(snapshot.data!, id);

        if (game == null) {
          return const Center(child: Text('Game not found'));
        }

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => context.go('/')),
            title: Text(game.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  game.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                const SizedBox(height: 16),
                Text(
                  game.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: _getGenreColor(game.genre),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      game.genre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Platform: ${game.platform}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Release Date: ${game.release_date}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Publisher: ${game.publisher}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Developer: ${game.developer}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  game.short_description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Text(
                  'Game Profile: ${game.freetogame_profile_url}',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
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
      case 'Action RPG':
        return Colors.red;
      case 'Shooter':
      case 'MOBA':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
