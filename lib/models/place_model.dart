import 'package:uuid/uuid.dart';

const uid = Uuid();

class Place {
  final String id;
  final String title;
  Place({required this.title}) : id = uid.v4();
}
