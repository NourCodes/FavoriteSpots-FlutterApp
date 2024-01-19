import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class MyMap extends StatelessWidget {
  double zoomIn;
  void Function(PickedData) pick;

  MyMap({
    super.key,
    required this.pick,
    required this.zoomIn,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLocationPicker(
        showCurrentLocationPointer: true,
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
        loadingWidget: const CircularProgressIndicator(),
        showContributorBadgeForOSM: true,
        initPosition: const LatLong(23.8859, 45.0792),
      ),
    );
  }
}
