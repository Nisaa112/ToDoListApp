import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_list_app/model/catatanPikiran_model.dart';
import 'package:to_do_list_app/model/difficulty_model.dart';
import 'package:to_do_list_app/model/kategori_model.dart';
import 'package:to_do_list_app/model/kategori_user_mode.dart';
import 'package:to_do_list_app/model/label_model.dart';
import 'package:to_do_list_app/model/lampiranTugas_model.dart';
import 'package:to_do_list_app/model/tugas_model.dart';
import 'package:to_do_list_app/model/tugas_sampingan_model.dart';
import 'package:to_do_list_app/model/catatanTugas_model.dart' as catatan;
import 'package:to_do_list_app/model/user_model.dart' as pengguna;
import 'package:to_do_list_app/model/ulangiTugas_model.dart' as ulangi;
import 'package:to_do_list_app/model/lampiranPikiran_model.dart' as lampiranp;

class DatabaseHelper {
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 3;

  // Table names
  static final tableKategori = 'kategori';
  static final tableTugas = 'tugas';
  static final tableLabel = 'label';
  static final tableUser = 'user';
  static final tableDifficulty = 'difficulty';
  static final tableKategoriUser = 'kategori_user';
  static final tableCatatanPikiran = 'catatan_pikiran';
  static final tableUlangiTugas = 'ulangi_tugas';
  static final tableLampiranTugas = 'lampiran_tugas';
  static final tableLampiranPikiran = 'lampiran_pikiran';
  static final tableCatatanTugas = 'catatan_tugas';
  static const String tableTugasSampingan = 'tugas_sampingan';

  // Common columns
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

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Contoh untuk upgrade dari versi 1 ke 2
    if (oldVersion < 2) {
      // Tambahkan kolom baru ke tabel tugas
      await db.execute('ALTER TABLE $tableTugas ADD COLUMN is_favorite INTEGER');
      await db.execute('ALTER TABLE $tableTugas ADD COLUMN is_archived INTEGER');

      // Pastikan tabel lain aman (tambahkan upgrade lain jika ada struktur baru)
      // Contoh: jika kamu pernah tambahkan tabel baru di versi 2, buatlah juga di sini
    }
  }


  Future _onCreate(Database db, int version) async {
    // Table Kategori
    await db.execute('''
      CREATE TABLE $tableKategori (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
    ''');

    // Table Label
    await db.execute('''
      CREATE TABLE $tableLabel (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        user_id INTEGER,
        $columnCreatedAt TEXT,
        $columnUpdatedAt TEXT
      )
    ''');

    // Table Tugas
    await db.execute('''
      CREATE TABLE tugas (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        category_id INTEGER,
        title TEXT,
        difficult TEXT,
        label_id INTEGER,
        due_date TEXT,
        date TEXT,
        is_checked INTEGER,
        is_favorite INTEGER,
        is_archived INTEGER 
      )
    ''');

    // Table User
    await db.execute('''
    CREATE TABLE $tableUser (
      id INTEGER PRIMARY KEY,
      name TEXT,
      email TEXT,
      photo_profile TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // Table difficulty
  await db.execute('''
    CREATE TABLE $tableDifficulty (
      id INTEGER PRIMARY KEY,
      name TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // Table kategori user
  await db.execute('''
    CREATE TABLE $tableKategoriUser (
      id INTEGER PRIMARY KEY,
      name TEXT,
      user_id INTEGER,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // Table catatan pikiran
  await db.execute('''
    CREATE TABLE $tableCatatanPikiran (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      judul TEXT,
      isi TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // Table ulangi tugas
  await db.execute('''
    CREATE TABLE $tableUlangiTugas (
      id INTEGER PRIMARY KEY,
      todo_id INTEGER,
      repeat_type TEXT,
      interval_days INTEGER,
      start_date TEXT,
      end_date TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  '''); 

  // Table lampiran tugas
  await db.execute('''
    CREATE TABLE $tableLampiranTugas (
      id INTEGER PRIMARY KEY,
      todo_id TEXT,
      file_path TEXT,
      file_type TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // table lampiran pikiran
  await db.execute('''
    CREATE TABLE $tableLampiranPikiran (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      catatan_pikiran_id TEXT,
      file_path TEXT,
      file_type TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // table catatan tugas
  await db.execute('''
    CREATE TABLE $tableCatatanTugas (
      id INTEGER PRIMARY KEY,
      todo_id INTEGER,
      note TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

  // Table tugas sampingan
  await db.execute('''
    CREATE TABLE $tableTugasSampingan (
      id INTEGER PRIMARY KEY,
      todo_id INTEGER,
      title TEXT,
      is_done INTEGER,
      created_at TEXT,
      updated_at TEXT
    )
  ''');


  }

  // ==================== Kategori ====================
  Future<int> insertKategori(KategoriModel kategori) async {
    final db = await database;
    return await db.insert(
      tableKategori, 
      kategori.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<bool> checkKategoriExists(String name) async {
    final db = await database;
    final result = await db.query(
      tableKategori,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  Future<void> clearKategoriTable() async {
    final db = await database;
    await db.delete(tableKategori);
  }

  // ==================== Label ====================
  Future<int> insertLabel(LabelModel label) async {
    final db = await database;
    return await db.insert(tableLabel, label.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearLabelByUser(int userId) async {
    final db = await database;
    await db.delete(tableLabel, where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<LabelModel>> getAllLabel({int? userId}) async {
    final db = await database;
    final result = await db.query(
      tableLabel,
      where: userId != null ? 'user_id = ?' : null,
      whereArgs: userId != null ? [userId] : null,
    );
    return result.map((json) => LabelModel.fromJson(json)).toList();
  }


  Future<int> updateLabel(LabelModel label) async {
    final db = await database;
    return await db.update(
      tableLabel,
      label.toJson(),
      where: 'id = ?',
      whereArgs: [label.id],
    );
  }

  Future<int> deleteLabel(int id) async {
    final db = await database;
    return await db.delete(
      tableLabel,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearLabelTable() async {
    final db = await database;
    await db.delete(tableLabel);
  }

  // ==================== Tugas ====================

  Future<int> insertTugas(TugasModel tugas) async {
    final db = await database;
    return await db.insert(
      tableTugas,
      tugas.toMap(), // ⬅️ gunakan toMap untuk SQLite
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearTugasByUser(int userId) async {
    final db = await database;
    await db.delete(tableTugas, where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<TugasModel>> getAllTugas({int? userId}) async {
    final db = await database;
    try {
      final maps = await db.query(
        tableTugas,
        where: userId != null ? 'user_id = ?' : null,
        whereArgs: userId != null ? [userId] : null,
      );
      print("✅ Jumlah tugas di database (userId: $userId): ${maps.length}");
      for (var m in maps) {
        print("🟡 Tugas: $m");
      }
      return List.generate(maps.length, (i) => TugasModel.fromMap(maps[i]));
    } catch (e) {
      print("❌ Error ambil tugas dari SQLite: $e");
      return [];
    }
  }


  Future<void> clearTugasTable() async {
    final db = await database;
    await db.delete(tableTugas);
  }

  Future<void> updateTugasChecked(int id, bool isChecked) async {
    final db = await database;
    await db.update(
      tableTugas,
      {'is_checked': isChecked ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<int> updateTugas(TugasModel tugas) async {
    final db = await database;
    return await db.update(
      tableTugas,
      tugas.toMap(), // ⬅️ gunakan toMap untuk SQLite
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

  Future<bool> checkTugasExists(int id) async {
    final db = await database;
    final result = await db.query(
      tableTugas,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }


  // Untuk User
  Future<int> insertUser(pengguna.Data user) async {
    final db = await database;
    await db.delete(tableUser); // Pastikan hanya 1 user
    return await db.insert(tableUser, user.toJson());
  }

  Future<pengguna.Data?> getUser() async {
    final db = await database;
    final result = await db.query(tableUser, limit: 1);
    if (result.isNotEmpty) {
      return pengguna.Data.fromJson(result.first);
    }
    return null;
  }

  Future<int> updateUser(pengguna.Data user) async {
    final db = await database;
    return await db.update(
      tableUser,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearUserTable() async {
    final db = await database;
    await db.delete(tableUser);
  }

  // crud difficulty
  Future<int> insertDifficulty(DifficultyModel difficulty) async {
    final db = await database;
    return await db.insert(tableDifficulty, difficulty.toJson());
  }

  Future<List<DifficultyModel>> getAllDifficulty() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(tableDifficulty);
    return result.map((e) => DifficultyModel.fromJson(e)).toList();
  }

  Future<int> updateDifficulty(DifficultyModel difficulty) async {
    final db = await database;
    return await db.update(
      tableDifficulty,
      difficulty.toJson(),
      where: 'id = ?',
      whereArgs: [difficulty.id],
    );
  }

  Future<int> deleteDifficulty(int id) async {
    final db = await database;
    return await db.delete(
      tableDifficulty,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDifficultyTable() async {
    final db = await database;
    await db.delete(tableDifficulty);
  }

  // CRUD kategori user
  Future<void> clearKategoriUserByUser(int userId) async {
    final db = await database;
    await db.delete(tableKategoriUser, where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> insertKategoriUser(KategoriUserModel kategoriUser) async {
    final db = await database;
    return await db.insert(tableKategoriUser, kategoriUser.toJson());
  }

  Future<List<KategoriUserModel>> getAllKategoriUser({int? userId}) async {
    final db = await database;
    try {
      final maps = await db.query(
        tableKategoriUser,
        where: userId != null ? 'user_id = ?' : null,
        whereArgs: userId != null ? [userId] : null,
      );
      print("✅ Kategori user dari SQLite (userId: $userId): ${maps.length}");
      return maps.map((e) => KategoriUserModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Error ambil kategori user dari SQLite: $e");
      return [];
    }
  }


  Future<int> updateKategoriUser(KategoriUserModel kategoriUser) async {
    final db = await database;
    return await db.update(
      tableKategoriUser,
      kategoriUser.toJson(),
      where: 'id = ?',
      whereArgs: [kategoriUser.id],
    );
  }

  Future<int> deleteKategoriUser(int id) async {
    final db = await database;
    return await db.delete(
      tableKategoriUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearKategoriUserTable() async {
    final db = await database;
    await db.delete(tableKategoriUser);
  }

  // CRUD catatan pikiran
  Future<void> clearCatatanPikiranByUser(int userId) async {
    final db = await database;
    await db.delete(tableCatatanPikiran, where: 'user_id = ?', whereArgs: [userId]);
  }


  Future<int> insertCatatanPikiran(CatatanPikiranModel catatan) async {
    final db = await database;
    return await db.insert(tableCatatanPikiran, catatan.toJson());
  }

  Future<List<CatatanPikiranModel>> getAllCatatanPikiran({int? userId}) async {
    final db = await database;
    try {
      final result = await db.query(
        tableCatatanPikiran,
        where: userId != null ? 'user_id = ?' : null,
        whereArgs: userId != null ? [userId] : null,
      );
      print("✅ Jumlah catatan pikiran (userId: $userId): ${result.length}");
      return result.map((e) => CatatanPikiranModel.fromJson(e)).toList();
    } catch (e) {
      print("❌ Error ambil catatan pikiran dari SQLite: $e");
      return [];
    }
  }


  Future<int> updateCatatanPikiran(CatatanPikiranModel catatan) async {
    final db = await database;
    return await db.update(
      tableCatatanPikiran,
      catatan.toJson(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  Future<int> deleteCatatanPikiran(int id) async {
    final db = await database;
    return await db.delete(
      tableCatatanPikiran,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearCatatanPikiranTable() async {
    final db = await database;
    await db.delete(tableCatatanPikiran);
  }

  // Table ulangi tugas
  Future<int> insertUlangiTugas(ulangi.Data data) async {
    final db = await database;
    return await db.insert(tableUlangiTugas, data.toJson());
  }

  Future<List<ulangi.Data>> getAllUlangiTugas() async {
    final db = await database;
    final result = await db.query(tableUlangiTugas);
    return result.map((e) => ulangi.Data.fromJson(e)).toList();
  }

  Future<int> updateUlangiTugas(ulangi.Data data) async {
    final db = await database;
    return await db.update(
      tableUlangiTugas,
      data.toJson(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> deleteUlangiTugas(int id) async {
    final db = await database;
    return await db.delete(
      tableUlangiTugas,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearUlangiTugasTable() async {
    final db = await database;
    await db.delete(tableUlangiTugas);
  }

  // table lampiran tugas
  Future<int> insertLampiranTugas(LampiranTugasModel lampiran) async {
    final db = await database;
    return await db.insert(tableLampiranTugas, lampiran.toJson());
  }

  Future<List<LampiranTugasModel>> getAllLampiranTugas({int? todoId}) async {
    final db = await database;

    final result = (todoId != null)
        ? await db.query(
            tableLampiranTugas,
            where: 'todo_id = ?',
            whereArgs: [todoId],
          )
        : await db.query(tableLampiranTugas);

    return result.map((e) => LampiranTugasModel.fromJson(e)).toList();
  }


  Future<int> updateLampiranTugas(LampiranTugasModel lampiran) async {
    final db = await database;
    return await db.update(
      tableLampiranTugas,
      lampiran.toJson(),
      where: 'id = ?',
      whereArgs: [lampiran.id],
    );
  }

  Future<int> deleteLampiranTugas(int id) async {
    final db = await database;
    return await db.delete(
      tableLampiranTugas,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearLampiranTugasTable() async {
    final db = await database;
    await db.delete(tableLampiranTugas);
  }

  // table lampiran pikiran
  Future<int> insertLampiranPikiran(lampiranp.Data lampiran) async {
    final db = await database;
    return await db.insert(tableLampiranPikiran, lampiran.toJson());
  }

  Future<List<lampiranp.Data>> getAllLampiranPikiran() async {
    final db = await database;
    final result = await db.query(tableLampiranPikiran);
    return result.map((e) => lampiranp.Data.fromJson(e)).toList();
  }

  Future<int> updateLampiranPikiran(lampiranp.Data lampiran) async {
    final db = await database;
    return await db.update(
      tableLampiranPikiran,
      lampiran.toJson(),
      where: 'id = ?',
      whereArgs: [lampiran.id],
    );
  }

  Future<int> deleteLampiranPikiran(int id) async {
    final db = await database;
    return await db.delete(
      tableLampiranPikiran,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearLampiranPikiranTable() async {
    final db = await database;
    await db.delete(tableLampiranPikiran);
  }

  // table catatan tugas
  Future<int> insertCatatanTugas(catatan.Data catatan) async {
    final db = await database;
    return await db.insert(tableCatatanTugas, catatan.toJson());
  }

  Future<List<catatan.Data>> getAllCatatanTugas() async {
    final db = await database;
    final result = await db.query(tableCatatanTugas);
    return result.map((e) => catatan.Data.fromJson(e)).toList();
  }

  Future<int> updateCatatanTugas(catatan.Data catatan) async {
    final db = await database;
    return await db.update(
      tableCatatanTugas,
      catatan.toJson(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  Future<int> deleteCatatanTugas(int id) async {
    final db = await database;
    return await db.delete(
      tableCatatanTugas,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearCatatanTugasTable() async {
    final db = await database;
    await db.delete(tableCatatanTugas);
  }

  // table tugas sampingan
  Future<List<Data>> getTugasSampinganByTodoId(int todoId) async {
    final db = await database;
    final result = await db.query(
      tableTugasSampingan,
      where: 'todo_id = ?',
      whereArgs: [todoId],
    );
    return result.map((e) => Data.fromJson(e)).toList();
  }


  Future<int> insertTugasSampingan(Data tugas) async {
    final db = await database;
    return await db.insert(tableTugasSampingan, tugas.toJson());
  }

  Future<List<Data>> getAllTugasSampingan() async {
    final db = await database;
    final result = await db.query(tableTugasSampingan);
    return result.map((e) => Data.fromJson(e)).toList();
  }

  Future<int> updateTugasSampingan(Data tugas) async {
    final db = await database;
    return await db.update(
      tableTugasSampingan,
      tugas.toJson(),
      where: 'id = ?',
      whereArgs: [tugas.id],
    );
  }

  Future<int> deleteTugasSampingan(int id) async {
    final db = await database;
    return await db.delete(
      tableTugasSampingan,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTugasSampinganTable() async {
    final db = await database;
    await db.delete(tableTugasSampingan);
  }
}
