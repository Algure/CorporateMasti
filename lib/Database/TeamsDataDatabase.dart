import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../DataObjects/TeamDataObject.dart';


class TeamsDataDb{

  Future<Database> createDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'doggieteamdata_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE TeamsData(i TEXT PRIMARY KEY, e TEXT, t TEXT)",);
      },
      version: 1,);
  }

  Future<void> insertItem({String id,TeamData teamData}) async {
    // Get a reference to the database.
    final Database db = await createDatabase();
    teamData.i=id;
    await db.insert(
      'TeamsData',
      teamData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(String id) async {
    // Get a reference to the database.
    final db = await createDatabase();
    // Remove the Dog from the Database.
    await db.delete(
      'TeamsData',
      // Use a `where` clause to delete a specific dog.
      where: "i = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


  Future<TeamData> getItem(String id) async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Remove the Dog from the Database.
    final List<Map<String, dynamic>> maps = await db.query(
      'TeamsData',
      // Use a `where` clause to check a specific dog.
      where: "i = ?",
      whereArgs: [id],
    );

    if(maps.isEmpty) return null;
    List<TeamData> mList= List.generate(maps.length, (i) {
      return TeamData.fromMap(maps[i]);
    });

    if(mList.isEmpty) return null;

    return mList[0];
  }

  Future< List<TeamData>> getAllTeamData(String teamId) async {
    // Get a reference to the database.
    final db = await createDatabase();

    // Remove the Dog from the Database.
    final List<Map<String, dynamic>> maps = await db.query(
      'TeamsData',
      // Use a `where` clause to check a specific dog.
      where: "t = ?",
      whereArgs: [teamId],
    );
    if(maps.isEmpty) return null;
    List<TeamData> mList= List.generate(maps.length, (i) {
      return TeamData.fromMap(maps[i]);
    });
    return mList;
  }

  Future<List<TeamData>> getTeamsData() async {
    // Get a reference to the database.
    final Database db = await createDatabase();
    // Query the table for all The Itemss.
    final List<Map<String, dynamic>> maps = await db.query('TeamsData');
    // Convert the List<Map<String, dynamic> into a List<MartItem>.
    return List.generate(maps.length, (i) {
      return TeamData.fromMap(maps[i]);
    });
  }

  Future<List<String>> getEventsStrings() async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    // Query the table for all The Itemss.
    final List<Map<String, dynamic>> maps = await db.query('TeamsData');

    // Convert the List<Map<String, dynamic> into a List<MartItem>.
    return List.generate(maps.length, (i) {
      return(maps[i].toString());
    });
  }
}