import 'package:favorite_spots_app/pages/add_place.dart';
import 'package:favorite_spots_app/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/places_list.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //listens to data changes
    final placesList = ref.watch(placeProvider);
    Widget screen = Center(
      child: Text(
        "No Places Found!",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    );
    if (placesList.isNotEmpty) {
      screen = Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlaceList(
          places: placesList,
        ),
      );
    }

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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPlace(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 25,
            ),
          ),
        ],
      ),
      body: screen,
    );
  }
}
