import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import '../models/recent_search.dart';

class DBHelper {
  static Database? _database;
  static const int version = 1;
  static const String tableName = 'LastUpdate';
////CREATING DATABASE METHODE
  static Future<void> initDB() async {
    if (_database != null) {
      debugPrint('database exist already ================================');
      return;
    } else {
      try {
        final String path = '${await getDatabasesPath()}weather.db';
        debugPrint(path);
        _database = await openDatabase(
          path,
          version: version,
          onCreate: (db, version) async {
            await db.execute('''
                              CREATE TABLE LastUpdate (
                                  id INTEGER PRIMARY KEY ,
                                  lastUpdate TEXT
                              );

                                                                          ''');
            await db.execute('''
                                  CREATE TABLE RecentSearch (
                                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                                  name TEXT,
                                  lat REAL,
                                  lon REAL
                              );
''');
            int number = await db.insert(
                'RecentSearch',
                {
                  'name': 'Ghardaia',
                  'lat': 32.4944,
                  'lon': 3.6445,
                },
                conflictAlgorithm: ConflictAlgorithm.replace);
            await db.insert(
                'RecentSearch',
                {
                  'name': 'Alger',
                  'lat': 36.7538,
                  'lon': 3.0588,
                },
                conflictAlgorithm: ConflictAlgorithm.replace);
            await db.insert(
                'RecentSearch',
                {
                  'name': 'Oran',
                  'lat': 35.6987,
                  'lon': -0.6349,
                },
                conflictAlgorithm: ConflictAlgorithm.replace);
            await db.insert(
                'RecentSearch',
                {
                  'name': 'Annaba',
                  'lat': 36.9142,
                  'lon': 7.7427,
                },
                conflictAlgorithm: ConflictAlgorithm.replace);

            debugPrint(
                'database created ================================== $number');
            // return ;
          },
        );
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            backgroundColor: Colors.red,
            gravity: ToastGravity.BOTTOM);
      }
    }
  }

  /// INSERT LASTUPDATE
  Future<void> insert() async {
    try {
      _database!.insert('LastUpdate',
          {'id': 1, 'lastUpdate': DateFormat('jm').format(DateTime.now())},
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///SELECTE THE LAST RAW OF LAST UPDATE
  Future<String?> selecetLastUpdate() async {
    try {
      List<Map<String, dynamic>> list = await _database!.rawQuery(
        '''
                                                                    SELECT *
                                                                    FROM LastUpdate
                                                                    WHERE id = 1;
                                                                                  ''',
      );
      return list[0]['lastUpdate'].toString();
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM);
      return e.toString();
    }
  }

  Future<void> addLastUpdate(String? lastUpdate) async {
    try {
      await _database!.update('LastUpdate', {'lastUpdate': lastUpdate},
          where: 'id=?', whereArgs: [1]);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM);

      return;
    }
  }

  //recent search part:::::::::::::::::::::::::::::::::::::::
  //INITIALIZE THE TABLE
  // Future<void> insertRecentSearch() async {
  //   try {
  //     await _database!.insert(
  //         'RecentSearch',
  //         {
  //           'name': 'Ghardaia',
  //           'lat': 32.4944,
  //           'lon': 3.6445,
  //         },
  //         conflictAlgorithm: ConflictAlgorithm.replace);
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: e.toString(),
  //       backgroundColor: Colors.red,
  //     );
  //   }
  // }

  // ADD LAST RECENT SSEARCH ITEM::::::::::::::::::::::::::::
  Future<void> addRecentSearch(RecentSearch recentSearch) async {
    try {
      _database!.insert(
        'RecentSearch',
        {
          'name': recentSearch.name,
          'lat': recentSearch.lat,
          'lon': recentSearch.lon,
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  ///SELECTE THE LAST 5 RAWs OF RECENT SEARCH :::::::::::::::::::::::::::::::::;
  Future<List<String>> selecetRecentSearch() async {
    List<String> listOfRecent = [];
    try {
      List<Map> list =
          await _database!.rawQuery('select * from RecentSearch ;');

      for (var i = 0; i < list.length; i++) {
        listOfRecent.add(list[i]['name']);
      }
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM);
    }
    return listOfRecent;
  }

//ADD TO

}
