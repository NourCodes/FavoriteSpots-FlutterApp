import 'package:riverpod/riverpod.dart';

import '../models/place_model.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  void addPlace(String place) {
    final newPlace = Place(
      title: place,
    );
    state = [
      ...state,
      newPlace,
    ];
  }
}

final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
