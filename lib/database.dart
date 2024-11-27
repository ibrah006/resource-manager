

import 'package:path/path.dart';
import 'package:resource_manager/entry.dart';
import 'package:resource_manager/item.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  // Initialize the database

  // Singleton pattern
  // static final LocalDatabase instance = LocalDatabase._privateConstructor();
  // LocalDatabase._privateConstructor();

  static const _databaseName = "resource_manager.db";

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create tables
  static Future _onCreate(Database db, int version) async {

    await db.execute('PRAGMA foreign_keys = ON;');

    // Create items table
    await db.execute('''
      CREATE TABLE ${Item.TABLENAME} (
        itemId TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        quantityBought INTEGER NOT NULL,
        quantitySold INTEGER NOT NULL,
        totalBought REAL NOT NULL,
        totalSold REAL NOT NULL
      )
    ''');

    // Create entries table with foreign key reference to items
    await db.execute('''
      CREATE TABLE ${Entry.TABLENAME} (
        itemId TEXT,
        entryId TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        dateTime INTEGER NOT NULL,
        price REAL NOT NULL,
        isSell INTEGER NOT NULL,
        category TEXT,
        FOREIGN KEY(itemId) REFERENCES items(itemId)
      )
    ''');
  }

  // Fetch all entries
  static Future<List<Entry>> getAllEntries() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(Entry.TABLENAME);
    return List.generate(maps.length, (i) {
      return Entry.fromJson(maps[i]);
    });
  }

  // Fetch all items
  Future<List<Item>> getAllItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(Item.TABLENAME);
    return List.generate(maps.length, (i) {
      return Item.fromJson(maps[i]);
    });
  }

}