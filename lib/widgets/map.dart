import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class Maps extends StatelessWidget {
  final double lat;
  final double long;
  final double zoomIn;
  Maps({Key? key, required this.lat, required this.long, required this.zoomIn})
      : super(key: key);
  MapController? controller;
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialCenter: LatLng(lat, long),
        initialZoom: zoomIn,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(
                lat,
                long,
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
