import 'package:favorite_spots_app/pages/add_place.dart';
import 'package:favorite_spots_app/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place_model.dart';
import '../widgets/places_list.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  PlaceLoc? selectedLoc;

  late Future<void> placeFuture;

  @override
  void initState() {
    super.initState();
    // Loading the data for the list of places
    placeFuture = ref.read(placeProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    //listens to data changes
    final placesList = ref.watch(placeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Spots',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.black,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(
              0.6,
            ),
        actions: [
          IconButton(
            onPressed: () async {
              final selectedLocation = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPlace(),
                ),
              );
              selectedLoc = selectedLocation;
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
      body: (placesList.isEmpty)
          ? Center(
              child: Text(
                "No Places Found!",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: placeFuture,
                builder: (context, snapshot) =>
                    (snapshot.connectionState == ConnectionState.waiting)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : PlaceList(
                            selectedLoc: selectedLoc,
                            places: placesList,
                          ),
              ),
            ),
    );
  }
}
