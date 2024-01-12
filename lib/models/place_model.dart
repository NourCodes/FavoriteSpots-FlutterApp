import 'dart:io';
import 'package:uuid/uuid.dart';

const uid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLoc? loc;
  Place({
    required this.title,
    required this.image,
    required this.loc,
  }) : id = uid.v4();
}

class PlaceLoc {
  final double lat;
  final double long;
  PlaceLoc({
    required this.long,
    required this.lat,
  });
}
