import 'dart:io';
import 'package:uuid/uuid.dart';

const uid = Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  Place({required this.title, required this.image}) : id = uid.v4();
}
