import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/book.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;
  const BookDetailPage({required this.bookId, super.key});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final DBService _db = DBService();
  Book? _book;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final b = await _db.getBookById(widget.bookId);
    setState(() {
      _book = b;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_book == null) return const Scaffold(body: Center(child: Text('Kitap bulunamadı')));
    final b = _book!;
    return Scaffold(
      appBar: AppBar(title: Text(b.title)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            if (b.coverUrl.isNotEmpty) Image.network(b.coverUrl, height: 200),
            const SizedBox(height: 8),
            Text('Yazar(lar): ${b.authors}'),
            Text('Yayınevi: ${b.publisher}'),
            Text('Yayın tarihi: ${b.publishedDate}'),
            Text('ISBN: ${b.isbn}'),
            Text('Sayfa sayısı: ${b.pageCount}'),
            Text('Raf: ${b.location}'),
            Text('Durum: ${b.status}'),
            const SizedBox(height: 12),
            Text('Not: ${b.note}'),
          ],
        ),
      ),
    );
  }
}
