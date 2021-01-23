import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../DataObjects/EventData.dart';

class TournamentsDb{

  Future<Database> createDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'doggietnm_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Tournaments(l TEXT PRIMARY KEY, e TEXT)",);
      },
      version: 1,);
  }

  Future<void> insertItem({String id,String item}) async {
    // Get a reference to the database.
    final Database db = await createDatabase();
    EventData ed=EventData.withDetails(id, item);
    await db.insert(
      'Tournaments',
      ed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(String id) async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Remove the Dog from the Database.
    await db.delete(
      'Tournaments',
      // Use a `where` clause to delete a specific dog.
      where: "l = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<EventData> getItem(String id) async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Remove the Dog from the Database.
    final List<Map<String, dynamic>> maps = await db.query(
      'Tournaments',
      // Use a `where` clause to check a specific dog.
      where: "l = ?",
      whereArgs: [id],
    );

    if(maps.isEmpty) return null;
    List<EventData> mList= List.generate(maps.length, (i) {
      return EventData.fromMap(maps[i]);
    });

    if(mList.isEmpty) return null;

    return mList[0];
  }

  Future<List<EventData>> getEvents() async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    // Query the table for all The Itemss.
    final List<Map<String, dynamic>> maps = await db.query('Tournaments');

    // Convert the List<Map<String, dynamic> into a List<MartItem>.
    return List.generate(maps.length, (i) {
      return EventData.fromMap(maps[i]);
    });
  }

  Future<List<String>> getEventsStrings() async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    // Query the table for all The Itemss.
    final List<Map<String, dynamic>> maps = await db.query('Tournaments');

    // Convert the List<Map<String, dynamic> into a List<MartItem>.
    return List.generate(maps.length, (i) {
      return(maps[i].toString());
    });
  }
}