import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import 'add_book_page.dart';
import 'book_detail_page.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evde Kütüphane'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => prov.loadBooks(),
            tooltip: 'Yenile',
          )
        ],
      ),
      body: prov.books.isEmpty
          ? const Center(child: Text('Kayıtlı kitap yok. Yeni kitap ekleyin.'))
          : ListView.builder(
              itemCount: prov.books.length,
              itemBuilder: (context, i) {
                final b = prov.books[i];
                return ListTile(
                  leading: (b.coverUrl.isNotEmpty)
                      ? Image.network(b.coverUrl, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.book),
                  title: Text(b.title),
                  subtitle: Text(b.authors),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => prov.deleteBook(b.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BookDetailPage(bookId: b.id)),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBookPage()),
        ),
      ),
    );
  }
}
