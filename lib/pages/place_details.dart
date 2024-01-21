import 'package:flutter/material.dart';
import '../models/place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PlaceDetails extends StatefulWidget {
  Place place;
  PlaceLoc? selectedLocation;

  PlaceDetails(
      {super.key, required this.place, required this.selectedLocation});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  String? address;

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
    }

    // get current position with high accuracy
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // get address from position
    address = await getAddress(position);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            widget.place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                  child: Text(
                    widget.place.loc.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
