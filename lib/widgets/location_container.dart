import 'package:favorite_spots_app/models/place_model.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'map.dart';

class LocationContainer extends StatefulWidget {
  final void Function(PlaceLoc location) onSelectedLoc;
  const LocationContainer({Key? key, required this.onSelectedLoc})
      : super(key: key);

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  var getLocation = false;
  PlaceLoc? selectedLocation;

  Maps get locationPic {
    final lat = selectedLocation!.lat;
    final long = selectedLocation!.long;
    return Maps(
      lat: lat,
      long: long,
      zoomIn: 17.0,
    );
  }

  void getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    PermissionStatus permissionGranted;
    LocationData locationData;

    if (!serviceEnabled) {
      return;
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.denied) {
        return;
      }
    }

    setState(() {
      getLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      selectedLocation = PlaceLoc(
        long: locationData.longitude!,
        lat: locationData.latitude!,
      );
      getLocation = false;
    });
    widget.onSelectedLoc(selectedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Text(
      "No Selected Location",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (selectedLocation != null) {
      screen = locationPic;
    }
    if (getLocation) {
      screen = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
            child: screen),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get Location"),
            ),
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Maps(
                    zoomIn: 10.0,
                    lat: selectedLocation?.lat ?? 51.509364,
                    long: selectedLocation?.long ?? -0.128928,
                  ),
                ),
              ),
              icon: const Icon(Icons.map),
              label: const Text(
                "Select on Map",
              ),
            ),
          ],
        )
      ],
    );
  }
}
