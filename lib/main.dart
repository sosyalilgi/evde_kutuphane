import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/book_list_page.dart';
import 'providers/book_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookProvider()..loadBooks(),
      child: MaterialApp(
        title: 'Evde Kütüphane',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const BookListPage(),
        locale: const Locale('tr', 'TR'),
      ),
    );
  }
}
