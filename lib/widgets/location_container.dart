import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationContainer extends StatefulWidget {
  const LocationContainer({Key? key}) : super(key: key);

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  var getLocation = false;
  Location? selectedLocation;
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
    print(locationData.latitude);
    setState(() {
      getLocation = false;
    });
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
              onPressed: () {},
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
