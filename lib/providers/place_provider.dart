import 'dart:io';
import 'package:riverpod/riverpod.dart';
import '../models/place_model.dart';
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  Future<Database> getDb() async {
    final dataPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dataPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, long REAL, address TEXT)');
      },
      version: 1,
    );
    return db;
  }

  Future<void> deletePlace(String id) async {
    final db = await getDb();
    await db.delete('user_places', where: 'id = ?', whereArgs: [id]);
    state = state.where((place) => place.id != id).toList();
  }

  Future<void> loadData() async {
    final db = await getDb();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            loc: PlaceLoc(
              lat: row['lat'] as double,
              long: row['long'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String place, File image, PlaceLoc placeLoc) async {
    final appDirectory = await sysPath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDirectory.path}/$filename');
    final newPlace = Place(
      loc: placeLoc,
      title: place,
      image: copiedImage,
    );
    final db = await getDb();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.loc.lat,
      'long': newPlace.loc.long,
      'address': newPlace.loc.address,
    });
    state = [
      ...state,
      newPlace,
    ];
  }
}

final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
