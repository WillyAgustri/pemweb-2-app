import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/destination.dart';

class DestinationPage extends StatelessWidget {
  final int? id;

  const DestinationPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {

    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Destination Not Found')),
        body: const Center(child: Text('Invalid destination ID')),
      );
    }

    Destination? findDestinationByID(List<Destination> destination, int id) {
      try {
        return destination.firstWhere((d) => d.id == id);
      } catch (e) {
        return null;
      }
    }

    return FutureBuilder<List<Destination>>(
        future: loadDestinations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading destination'));
          }

          final destination = findDestinationByID(snapshot.data!, id!);

          if (destination == null) {
            return const Center(child: Text('Destination not found'));
          }

          return Scaffold(
              appBar: AppBar(
                  leading: BackButton(onPressed: () => context.pop()),
                  title: const Text('Destinasi')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(destination.image),
                    const SizedBox(height: 16),
                    Text(
                      destination.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text(destination.address),
                    const SizedBox(height: 16,),
                    Text(destination.description),
                  ],
                ),
              ));
        });
  }
}
