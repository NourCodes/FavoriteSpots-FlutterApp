import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../pages/place_details.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/place_provider.dart';

class PlaceList extends ConsumerWidget {
  PlaceLoc? selectedLoc;
  List<Place> places;

  PlaceList({
    super.key,
    required this.places,
    required this.selectedLoc,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          margin: Theme.of(context).cardTheme.margin,
          child: const Center(
            child: Icon(Icons.delete),
          ),
        ),
        onDismissed: (direction) {
          ref.read(placeProvider.notifier).deletePlace(places[index].id);
        },
        key: ValueKey(places[index].id),
        child: ListTile(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlaceDetails(
                  place: places[index], selectedLocation: selectedLoc),
            ),
          ),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: FileImage(places[index].image),
          ),
          title: Text(
            places[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(places[index].loc.address),
        ),
      ),
    );
  }
}
