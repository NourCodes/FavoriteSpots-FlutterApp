import 'dart:io';
import 'package:riverpod/riverpod.dart';
import '../models/place_model.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  void addPlace(String place, File image, PlaceLoc placeLoc) {
    final newPlace = Place(
      loc: placeLoc,
      title: place,
      image: image,
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
