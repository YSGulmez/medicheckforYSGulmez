import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/ilacmod.dart';


class SQLiteHelper {
  Database? _database;
  String? _dbPath;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDBMethod();
    return _database!;
  }

  Future<String> get dbPath async {
    if (_dbPath != null) {
      return _dbPath!;
    }
    _dbPath = await dbPathMethod();

    return _dbPath!;
  }

  Future<Database> openDBMethod() async {
    debugPrint("***********************OPENDBMethod**************");
    String? dbPath = await dbPathMethod();
    debugPrint("**************** dbPath: $dbPath");
    return await databaseFactory.openDatabase(
      dbPath!,
      options: OpenDatabaseOptions(
        onCreate: onCreate,
        version: 1,
      ),
    );
  }

  Future<String?> dbPathMethod() async {
    debugPrint("************************* dbPathMethod");
    Directory documDricet = await getApplicationDocumentsDirectory();
    debugPrint(
        " ******************** databasespath.path : ${documDricet.path}");

    String dbPath = p.join(documDricet.path, "databases", "ılacdata.db");
    return dbPath;
  }

  Future<FutureOr<void>> onCreate(Database database, int version) async {
    final db = database;

    await db.execute("""
    CREATE TABLE IF NOT EXISTS IlacModel(
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL,
  number INT NOT NULL,
  date TEXT NOT NULL,
  gorsel TEXT NOT NULL,
  aciklama TEXT
)
        """);

    debugPrint(" ********************  helper database initilazed");
  }

  Future<int> insterdata(IlacModel ilacmodel) async {
    Database db = await database;

    try {
      debugPrint("insert işlemi başlandı");
      debugPrint("dataModel.toJson(): ${ilacmodel.toMap().toString()}");

      int id = await db.insert("IlacModel", ilacmodel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint("id: $id");
      return id;
    } catch (e) {
      debugPrint(" Sorun oluştu");
      debugPrint(e.toString());

      return -1;
    } finally {
      debugPrint("insert işlemi tamamlandi");
    }
  }

  Future<List<IlacModel>> searchData(String keyword) async {
    final Database db = await database;
    List<Map<String, Object?>> searchResult = await db.rawQuery(
      "select * from notes where noteTitle LIKE ?",
      ["%$keyword%"],
    );
    return searchResult.map((e) => IlacModel.fromMap(e)).toList();
  }

  Future<List<IlacModel>> getIlacdata() async {
    Database db = await database;
    debugPrint("ılacdata  --db!.isOpen: ${db.isOpen}");
    final List<Map<String, dynamic>> maps = await db.query('IlacModel');

    debugPrint(maps.toList().toString());

    return List.generate(
      maps.length,
      (index) {
        return IlacModel(
          id: maps[index]['id'],
          name: maps[index]['name'],
          date: maps[index]['date'],
          gorsel: maps[index]['gorsel'],
          number: maps[index]['number'],
          aciklama: maps[index]['aciklama'],
        );
      },
    );
  }

  Future<int> updateIlacData(IlacModel ilacModel) async {
    Database db = await database;

    try {
      debugPrint("update işlemi başlandı");
      debugPrint("dataModel.toJson(): ${ilacModel.toMap().toString()}");

      int rowsAffected = await db.update(
        'IlacModel',
        ilacModel.toMap(),
        where: 'id = ?',
        whereArgs: [ilacModel.id],
      );
      debugPrint("rowsAffected: $rowsAffected");
      return rowsAffected;
    } catch (e) {
      debugPrint("Sorun oluştu");
      debugPrint(e.toString());
      return -1;
    } finally {
      debugPrint("update işlemi tamamlandi");
    }
  }

  Future<int> deleteIlacData(int id) async {
    Database db = await database;

    try {
      debugPrint("delete işlemi başlandı");
      int rowsAffected = await db.delete(
        'IlacModel',
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint("rowsAffected: $rowsAffected");
      return rowsAffected;
    } catch (e) {
      debugPrint("Sorun oluştu");
      debugPrint(e.toString());
      return -1;
    } finally {
      debugPrint("delete işlemi tamamlandi");
    }
  }
}
