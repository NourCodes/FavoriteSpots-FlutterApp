import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class Maps extends StatefulWidget {
  // Required parameters for initializing the Maps widget
  final double lat;
  final double long;
  final double zoomIn;
  Maps({Key? key, required this.lat, required this.long, required this.zoomIn})
      : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  // controller for managing the map state
  late MapController _mapController;

  @override
  void initState() {
    _mapController = MapController();

    super.initState();
  }

  // method to move the map center to the specified coordinates
  void locateCenter() {
    _mapController.move(
        LatLng(widget.lat, widget.long),
        widget
            .zoomIn); // move to the specified location with a zoom level of 18.0
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        onPositionChanged: (position, hasGesture) {
          if (hasGesture) {
            setState(() {
              locateCenter();
            });
          }
        },
        initialCenter: LatLng(widget.lat, widget.long),
        onMapReady: () {
          setState(() {
            // ensure that the map centers on the selected location when it's ready
            locateCenter();
          });
        },
        initialZoom: widget.zoomIn,
      ),
      children: [
        // adding a tile layer with OpenStreetMap as the source
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          subdomains: ['a', 'b', 'c'],
        ),
        // adding a marker layer with a pin icon at the specified coordinates
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                widget.lat,
                widget.long,
              ),
              child: Icon(
                Icons.pin_drop_rounded,
                color: Colors.grey.shade700,
                size: 50,
              ),
            )
          ],
        ),
      ],
    );
  }
}
