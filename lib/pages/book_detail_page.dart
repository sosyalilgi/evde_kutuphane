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
  late TextEditingController _noteCtrl;
  final _statusOptions = const [
    'available',
    'reading',
    'finished',
    'lent',
  ];

  @override
  void initState() {
    super.initState();
    _noteCtrl = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final b = await _db.getBookById(widget.bookId);
    setState(() {
      _book = b;
      _loading = false;
      if (b != null) {
        _noteCtrl.text = b.note;
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_book == null) return;
    final updated = Book(
      id: _book!.id,
      title: _book!.title,
      authors: _book!.authors,
      publisher: _book!.publisher,
      publishedDate: _book!.publishedDate,
      isbn: _book!.isbn,
      pageCount: _book!.pageCount,
      language: _book!.language,
      coverUrl: _book!.coverUrl,
      tags: _book!.tags,
      location: _book!.location,
      status: _book!.status,
      lentTo: _book!.lentTo,
      note: _noteCtrl.text,
      createdAt: _book!.createdAt,
    );
    await _db.updateBook(updated);
    setState(() {
      _book = updated;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Değişiklikler kaydedildi')),
      );
    }
  }

  Future<void> _changeStatus(String newStatus) async {
    if (_book == null) return;
    final updated = Book(
      id: _book!.id,
      title: _book!.title,
      authors: _book!.authors,
      publisher: _book!.publisher,
      publishedDate: _book!.publishedDate,
      isbn: _book!.isbn,
      pageCount: _book!.pageCount,
      language: _book!.language,
      coverUrl: _book!.coverUrl,
      tags: _book!.tags,
      location: _book!.location,
      status: newStatus,
      lentTo: _book!.lentTo,
      note: _noteCtrl.text,
      createdAt: _book!.createdAt,
    );
    await _db.updateBook(updated);
    setState(() {
      _book = updated;
    });
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_book == null) {
      return const Scaffold(body: Center(child: Text('Kitap bulunamadı')));
    }
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
            const SizedBox(height: 12),
            const Text(
              'Durum',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _statusOptions.contains(b.status) ? b.status : 'available',
              items: _statusOptions
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s)),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  _changeStatus(val);
                }
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Etiketler',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(b.tags.isEmpty ? '-' : b.tags),
            const SizedBox(height: 12),
            const Text(
              'Not',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _noteCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Bu kitapla ilgili notlarınızı yazın',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Notu Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'available':
        return 'Müsait';
      case 'reading':
        return 'Okunuyor';
      case 'finished':
        return 'Bitti';
      case 'lent':
        return 'Ödünç Verildi';
      default:
        return s;
    }
  }
}
