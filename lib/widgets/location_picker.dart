import 'package:favorite_spots_app/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MyMap extends StatelessWidget {
  double zoomIn;
  void Function(PickedData) change;
  void Function(PickedData) pick;

  String? address;
  MyMap({
    super.key,
    required this.change,
    required this.pick,
    required this.zoomIn,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLocationPicker(
        initZoom: zoomIn,
        minZoomLevel: 5,
        maxZoomLevel: 16,
        trackMyPosition: true,
        searchBarBackgroundColor: Colors.white,
        selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
        mapLanguage: 'en',
        onError: (e) => print(e),
        selectLocationButtonLeadingIcon: const Icon(Icons.check),
        onPicked: (pickedData) => pick(pickedData),
        onChanged: (pickedData) => change(pickedData),
        showContributorBadgeForOSM: true,
      ),
    );
  }
}
