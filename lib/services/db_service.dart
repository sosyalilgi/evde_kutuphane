import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'evde_kutuphane.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT,
        authors TEXT,
        publisher TEXT,
        publishedDate TEXT,
        isbn TEXT,
        pageCount INTEGER,
        language TEXT,
        coverUrl TEXT,
        tags TEXT,
        location TEXT,
        status TEXT,
        lentTo TEXT,
        note TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<void> insertBook(Book book) async {
    final database = await db;
    await database.insert('books', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getAllBooks() async {
    final database = await db;
    final maps = await database.query('books', orderBy: 'createdAt DESC');
    return maps.map((m) => Book.fromMap(m)).toList();
  }

  Future<Book?> getBookById(String id) async {
    final database = await db;
    final maps = await database.query('books', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Book.fromMap(maps.first);
  }

  Future<void> updateBook(Book book) async {
    final database = await db;
    await database
        .update('books', book.toMap(), where: 'id = ?', whereArgs: [book.id]);
  }

  Future<void> deleteBook(String id) async {
    final database = await db;
    await database.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
