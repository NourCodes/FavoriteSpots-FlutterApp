import 'package:favorite_spots_app/models/place_model.dart';
import 'package:favorite_spots_app/widgets/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'map.dart';
import 'package:geolocator/geolocator.dart';

/// widget for managing location container
class LocationContainer extends StatefulWidget {
  /// callback for handling selected location
  final void Function(PlaceLoc location) onSelectedLoc;
  const LocationContainer({Key? key, required this.onSelectedLoc})
      : super(key: key);

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  // bool used to indicate location retrieval
  var getLocation = false;
  // selected location
  PlaceLoc? selectedLocation;
  // address
  String? address;

  // getters for location picture
  Maps get locationPic {
    final lat = selectedLocation?.lat;
    final long = selectedLocation?.long;
    return Maps(
      lat: lat!,
      long: long!,
      zoomIn: 5.0,
    );
  }

  // method to get current location
  Future<void> getCurrentLocation() async {
    // check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;

    // return an error if location services are disabled
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // check location permission
    permission = await Geolocator.checkPermission();

    // request permission if denied.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      }
    }

    // remove the circular indicator for location retrieval
    setState(() {
      getLocation = true;
    });

    // get current position with high accuracy
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // get address from position
    address = await getAddress(position);

    setState(() {
      selectedLocation = PlaceLoc(
        address: address!,
        long: position.longitude,
        lat: position.latitude,
      );
      getLocation = false;
    });

    // callback to parent widget with selected location
    widget.onSelectedLoc(selectedLocation!);
  }

  // method to get address from position
  Future<String?> getAddress(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${place.name} ${place.street} ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    });

    // return formatted address
    return address.toString();
  }

  @override
  Widget build(BuildContext context) {
    // default screen widget
    Widget screen = Text(
      "No Selected Location",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    // check if location is selected
    if (selectedLocation != null) {
      screen = locationPic;
    }

    // check if location retrieval is in progress
    if (getLocation) {
      screen = const CircularProgressIndicator();
    }

    // return the widget tree
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
          child: screen,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get Location"),
            ),
            TextButton.icon(
              onPressed: () {
                // navigate to map screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyMap(
                      zoomIn: 10.0,
                      change: (data) {
                        setState(() {
                          selectedLocation = PlaceLoc(
                              long: data.latLong.longitude,
                              lat: data.latLong.latitude,
                              address: data.address);
                        });
                      },
                      pick: (data) {
                        setState(() {
                          selectedLocation = PlaceLoc(
                              long: data.latLong.longitude,
                              lat: data.latLong.latitude,
                              address: data.address);
                          address = data.address;

                          // callback to parent widget with selected location
                          widget.onSelectedLoc(selectedLocation!);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
            ),
          ],
        )
      ],
    );
  }
}
