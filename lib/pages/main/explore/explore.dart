import 'package:app1/models/destination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Destination> destinations = [];
  List<Destination> filteredDestinations = [];

  @override
  void initState() {
    super.initState();
    loadDestinationsToPage();
  }

  Future<void> loadDestinationsToPage() async {
    final loadedDestinations = await loadDestinations();
    setState(() {
      destinations = loadedDestinations;
      filteredDestinations = destinations;
    });
  }

  void _filteredDestinations(String query) {
    setState(() {
      filteredDestinations = destinations
          .where((d) => d.name.toLowerCase().contains(query.toLowerCase()))
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
                  hintText: 'Cari Destinasi',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              onChanged: _filteredDestinations),
        ),
        const SizedBox(
          height: 20,
        ),
        filteredDestinations.isEmpty
            ? const Center(
                child: Text('Hasil tidak ditemukan'),
              )
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredDestinations.length,
                    itemBuilder: (context, index) {
                      final destination = filteredDestinations[index];
                      return Card(
                          elevation: 8,
                          margin: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    child: Image.network(
                                      destination.image,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 18, 0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    destination.name,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    destination.address,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ]),
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.thumb_up),
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                    destination.like.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12))
                                              ],
                                            ),
                                          )
                                        ])),
                                Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      destination.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 18),
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      context.push(
                                          '/destination?id=${destination.id}')
                                    },
                                    child: const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              ]));
                    }),
              ),
      ],
    ));
  }
}
