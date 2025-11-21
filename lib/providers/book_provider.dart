import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/book.dart';
import '../services/db_service.dart';

class BookProvider extends ChangeNotifier {
  final DBService _db = DBService();
  final _uuid = const Uuid();

  // Tüm kitaplar (ham liste) ve filtrelenmiş liste
  List<Book> _allBooks = [];
  List<Book> _books = [];
  String _query = '';

  List<Book> get books => _books;
  String get query => _query;

  Future<void> loadBooks() async {
    _allBooks = await _db.getAllBooks();
    _applyFilter();
  }

  Future<void> addBook({
    required String title,
    String authors = '',
    String publisher = '',
    String isbn = '',
    int pageCount = 0,
    String location = '',
    String tags = '',
    String note = '',
  }) async {
    final now = DateTime.now().toIso8601String();
    final book = Book(
      id: _uuid.v4(),
      title: title,
      authors: authors,
      publisher: publisher,
      isbn: isbn,
      pageCount: pageCount,
      location: location,
      tags: tags,
      note: note,
      createdAt: now,
    );
    await _db.insertBook(book);
    _allBooks.insert(0, book);
    _applyFilter();
  }

  Future<void> deleteBook(String id) async {
    await _db.deleteBook(id);
    _allBooks.removeWhere((b) => b.id == id);
    _applyFilter();
  }

  Future<void> updateBook(Book book) async {
    await _db.updateBook(book);
    final index = _allBooks.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _allBooks[index] = book;
      _applyFilter();
    }
  }

  // Arama/filtre
  void setQuery(String q) {
    _query = q;
    _applyFilter();
  }

  void _applyFilter() {
    if (_query.trim().isEmpty) {
      _books = List.unmodifiable(_allBooks);
    } else {
      final lower = _query.toLowerCase();
      _books = _allBooks.where((b) {
        return b.title.toLowerCase().contains(lower) ||
            b.authors.toLowerCase().contains(lower) ||
            b.tags.toLowerCase().contains(lower) ||
            b.isbn.toLowerCase().contains(lower);
      }).toList(growable: false);
    }
    notifyListeners();
  }
}
