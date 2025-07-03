import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list_app/model/kategori_model.dart';
import 'package:to_do_list_app/model/tugas_model.dart';

class DatabaseHelper {
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 1;

  static final tableKategori = 'kategori';
  static final tableTugas = 'tugas';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnCreatedAt = 'created_at';
  static final columnUpdatedAt = 'updated_at';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<bool> checkKategoriExists(String name) async {
    final db = await database;
    final result = await db.query(
      tableKategori,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableKategori (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTugas (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        category_id INTEGER,
        title TEXT,
        difficult TEXT,
        label_id INTEGER,
        due_date TEXT,
        date TEXT,
        is_checked INTEGER
      )
    ''');
  }

  Future<int> insertKategori(KategoriModel kategori) async {
    final db = await database;
    return await db.insert(tableKategori, kategori.toJson());
  }

  Future<List<KategoriModel>> getAllKategori() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableKategori);
    return maps.map((e) => KategoriModel.fromJson(e)).toList();
  }

  Future<int> updateKategori(KategoriModel kategori) async {
    final db = await database;
    return await db.update(
      tableKategori,
      kategori.toJson(),
      where: 'id = ?',
      whereArgs: [kategori.id],
    );
  }

  Future<int> deleteKategori(int id) async {
    final db = await database;
    return await db.delete(
      tableKategori,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearKategoriTable() async {
    final db = await database;
    await db.delete(tableKategori);
  }

  // ==================== Tugas ====================
  Future<int> insertTugas(TugasModel tugas) async {
    final db = await database;
    return await db.insert(tableTugas, tugas.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TugasModel>> getAllTugas() async {
    final db = await database;
    final result = await db.query(tableTugas);
    return result.map((json) => TugasModel.fromJson(json)).toList();
  }

  Future<void> clearTugasTable() async {
    final db = await database;
    await db.delete(tableTugas);
  }

  Future<int> updateTugas(TugasModel tugas) async {
    final db = await database;
    return await db.update(
      tableTugas,
      tugas.toJson(),
      where: 'id = ?',
      whereArgs: [tugas.id],
    );
  }

  Future<int> deleteTugas(int id) async {
    final db = await database;
    return await db.delete(
      tableTugas,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Optional: untuk mengecek apakah tugas dengan ID tertentu sudah ada
  Future<bool> checkTugasExists(int id) async {
    final db = await database;
    final result = await db.query(
      tableTugas,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

}
