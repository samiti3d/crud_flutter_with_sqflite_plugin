import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_flutter/models/car.dart';

class DatabaseHelper {
  static const _datbaseName = "cardb.db";
  static const _databaseVersion = 1;
  static const table = "car_table";
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnMiles = "miles";

  DatabaseHelper._privateContructor();
  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _datbaseName);
    print("PATH===> $path");
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int verison) async {
    await db.execute("""
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnMiles INTEGER NOT NULL
      )
    """);
  }

  Future<int?> insert(Car car) async {
    Database? db = await instance.database;
    return await db?.insert(table, {'name': car.name, 'miles': car.miles},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<int?> delete(int id) async {
    Database? db = await instance.database;
    return await db?.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
