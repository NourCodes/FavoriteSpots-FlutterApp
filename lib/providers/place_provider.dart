import 'dart:io';
import 'package:riverpod/riverpod.dart';
import '../models/place_model.dart';
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  // constructor initializing with an empty list of places
  PlacesNotifier() : super(const []);

  // method to obtain the database instance
  Future<Database> getDb() async {
    // get the path for databases
    final dataPath = await sql.getDatabasesPath();
    // open the database
    final db = await sql.openDatabase(
      path.join(dataPath, 'places.db'),
      onCreate: (db, version) {
        // execute SQL command to create the 'user_places' table
        return db.execute(
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, long REAL, address TEXT)');
      },
      version: 1,
    );
    return db;
  }

  // method to delete a place from the database
  Future<void> deletePlace(String id) async {
    // get the database instance
    final db = await getDb();
    // delete the place with the specified id
    await db.delete('user_places', where: 'id = ?', whereArgs: [id]);
    // update the state by removing the deleted place
    state = state.where((place) => place.id != id).toList();
  }

  // method to load data from the database
  Future<void> loadData() async {
    // get the database instance
    final db = await getDb();
    // query all data from the 'user_places' table
    final data = await db.query('user_places');
    // map the data to a list of Place objects
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
    // update the state with the loaded places
    state = places;
  }

  // method to add a new place to the database
  void addPlace(String place, File image, PlaceLoc placeLoc) async {
    // get the application documents directory
    final appDirectory = await sysPath.getApplicationDocumentsDirectory();
    // get the filename from the image path
    final filename = path.basename(image.path);
    // copy the image to the application documents directory
    final copiedImage = await image.copy('${appDirectory.path}/$filename');
    // create a new Place object with the provided data
    final newPlace = Place(
      loc: placeLoc,
      title: place,
      image: copiedImage,
    );
    // get the database instance
    final db = await getDb();
    // insert the new place into the 'user_places' table
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.loc.lat,
      'long': newPlace.loc.long,
      'address': newPlace.loc.address,
    });
    // update the state by adding the new place
    state = [
      ...state,
      newPlace,
    ];
  }
}

// provider for the places state notifier
final placeProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
