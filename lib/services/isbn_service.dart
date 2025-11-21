import 'dart:convert';
import 'package:http/http.dart' as http;

class IsbnService {
  // Open Library Books API
  // Örnek: https://openlibrary.org/api/books?bibkeys=ISBN:0451526538&format=json&jscmd=data
  Future<Map<String, dynamic>?> fetchByIsbn(String isbn) async {
    final url =
        'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return null;
    final Map<String, dynamic> data = json.decode(res.body);
    final key = 'ISBN:$isbn';
    if (!data.containsKey(key)) return null;
    final book = data[key] as Map<String, dynamic>;
    // Basit map: title, authors (string), publishers, publish_date, pages, cover
    final title = book['title']?.toString() ?? '';
    final authors = (book['authors'] as List<dynamic>?)
            ?.map((a) => a['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .join(', ') ??
        '';
    final publishers = (book['publishers'] as List<dynamic>?)
            ?.map((p) => p['name']?.toString() ?? '')
            .where((name) => name.isNotEmpty)
            .join(', ') ??
        '';
    final publishDate = book['publish_date']?.toString() ?? '';
    final pages = book['number_of_pages'] as int? ?? 0;
    final cover = (book['cover'] != null) ? book['cover']['medium']?.toString() ?? '' : '';

    return {
      'title': title,
      'authors': authors,
      'publisher': publishers,
      'publishedDate': publishDate,
      'pageCount': pages,
      'coverUrl': cover,
    };
  }
}
