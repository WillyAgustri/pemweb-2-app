import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> destinations = [];

  @override
  void initState() {
    super.initState();
    loadDestinations();
  }

  Future<void> loadDestinations() async {
    final response = await rootBundle.loadString('assets/tourism.json');
    final data = await json.decode(response);
    setState(() {
      destinations = data['destinations'];
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
      body: destinations.isEmpty
      ? const Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return Card(
            elevation: 8,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: Image.network(
                      destination['image'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 18, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: 
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(destination['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                destination['address'],
                                style: const TextStyle(
                                  fontSize: 14, 
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                          ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.thumb_up),
                              color: Colors.blue,
                            ),
                            Text(
                              destination['like'].toString(),
                              style: const TextStyle(fontSize: 12)
                            )
                          ],
                        ),
                      )
                    ]
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    destination['description'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  child: ElevatedButton(
                    onPressed: () => {
                      context.push('/destination?id=${destination['id']}')},
                    child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                          )
                        ],
                      ),
                  ),
                )
              ]
            )
          );
        },
      ),
    );
  }
}