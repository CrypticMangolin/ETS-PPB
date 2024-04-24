import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/film.dart';

class FilmDatabase {
  static final FilmDatabase instance = FilmDatabase._init();

  static Database? _database;

  FilmDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB('Film.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    var database = await openDatabase(
      path,
      // Version of the dataset
      version: 1,
      // Create database using this function if it does not exist yet
      onCreate: _createDB,
    );
    return database;
  }

  Future _createDB(Database db, int version) async {
    final String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final String textType = 'TEXT NOT NULL';

    await db.execute("""
    CREATE TABLE $filmTable (
    ${FilmFields.id} $idType,
    ${FilmFields.title} $textType,
    ${FilmFields.description} $textType,
    ${FilmFields.link} $textType,
    ${FilmFields.time} $textType
    );
    """);
  }

  Future<Film> createFilm(Film film) async {
    final db = await instance.database;
    final id = await db.insert(filmTable, film.toJson());
    return film.copy(id: id);
  }

  Future<Film> readFilm(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      filmTable,
      columns: FilmFields.values,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty) {
      return Film.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Film>> readAllFilm() async {
    final db = await instance.database;

    final order = '${FilmFields.time} ASC';
    final result = await db.query(filmTable, orderBy: order);

    return result.map((json) => Film.fromJson(json)).toList();
  }

  Future<int> updateFilm(Film film) async {
    final db = await instance.database;

    return db.update(
      filmTable,
      film.toJson(),
      where: '${FilmFields.id} = ?',
      whereArgs: [film.id],
    );
  }

  Future<int> deleteFilm(int id) async {
    final db = await instance.database;

    return db.delete(
      filmTable,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
