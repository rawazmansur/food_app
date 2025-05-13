import 'dart:io';
import 'package:flutter/services.dart';
import 'package:food/Model/DiscussionModel.dart';
import 'package:food/Model/topicModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'FoodApp.db');

    bool exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);

        ByteData data = await rootBundle.load('assets/database/FoodApp.db');
        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );

        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print("Error copying database: $e");
        rethrow;
      }
    }

    return await openDatabase(path);
  }

  Future<List<DiscussionModel>> getAllDiscussions() async {
    try {
      final db = await database;
      final res = await db.query('discussions');
      return res.isNotEmpty
          ? res.map((c) => DiscussionModel.fromJson(c)).toList()
          : [];
    } catch (e) {
      print('Error querying discussions: $e');
      rethrow;
    }
  }

  Future<List<topicModel>> getAllTopics() async {
    try {
      final db = await database;
      final res = await db.query('topics');
      return res.isNotEmpty
          ? res.map((c) => topicModel.fromJson(c)).toList()
          : [];
    } catch (e) {
      print('Error querying topics: $e');
      rethrow;
    }
  }
 
}
