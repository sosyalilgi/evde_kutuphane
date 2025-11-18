import 'package:flutter/foundation.dart';

class Book {
  String id;
  String title;
  String authors;
  String publisher;
  String publishedDate;
  String isbn;
  int pageCount;
  String language;
  String coverUrl;
  String tags;
  String location;
  String status; // available / lent / reading / finished
  String lentTo;
  String note;
  String createdAt;

  Book({
    required this.id,
    required this.title,
    this.authors = '',
    this.publisher = '',
    this.publishedDate = '',
    this.isbn = '',
    this.pageCount = 0,
    this.language = '',
    this.coverUrl = '',
    this.tags = '',
    this.location = '',
    this.status = 'available',
    this.lentTo = '',
    this.note = '',
    required this.createdAt,
  });

  factory Book.fromMap(Map<String, dynamic> m) => Book(
        id: m['id'] as String,
        title: m['title'] as String,
        authors: m['authors'] ?? '',
        publisher: m['publisher'] ?? '',
        publishedDate: m['publishedDate'] ?? '',
        isbn: m['isbn'] ?? '',
        pageCount: m['pageCount'] ?? 0,
        language: m['language'] ?? '',
        coverUrl: m['coverUrl'] ?? '',
        tags: m['tags'] ?? '',
        location: m['location'] ?? '',
        status: m['status'] ?? 'available',
        lentTo: m['lentTo'] ?? '',
        note: m['note'] ?? '',
        createdAt: m['createdAt'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'authors': authors,
        'publisher': publisher,
        'publishedDate': publishedDate,
        'isbn': isbn,
        'pageCount': pageCount,
        'language': language,
        'coverUrl': coverUrl,
        'tags': tags,
        'location': location,
        'status': status,
        'lentTo': lentTo,
        'note': note,
        'createdAt': createdAt,
      };
}
