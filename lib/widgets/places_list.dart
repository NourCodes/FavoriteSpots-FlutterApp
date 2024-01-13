import 'package:flutter/material.dart';
import '../models/place_model.dart';
import '../pages/place_details.dart';

class PlaceList extends StatelessWidget {
  List<Place> places;

  PlaceList({
    super.key,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetails(place: places[index]),
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
        subtitle: Text(places[index].loc!.address),
      ),
    );
  }
}
