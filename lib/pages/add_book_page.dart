import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/book_provider.dart';
import '../services/isbn_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _publisherCtrl = TextEditingController();
  final _isbnCtrl = TextEditingController();
  final _pagesCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _scanning = false;
  final IsbnService _isbnService = IsbnService();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _publisherCtrl.dispose();
    _isbnCtrl.dispose();
    _pagesCtrl.dispose();
    _locationCtrl.dispose();
    _tagsCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    setState(() => _scanning = true);
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 400,
        child: MobileScanner(
          onDetect: (capture) async {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isEmpty) return;
            final code = barcodes.first.rawValue ?? '';
            if (code.isEmpty) return;
            // Otomatik doldur
            Navigator.of(ctx).pop();
            _isbnCtrl.text = code;
            final data = await _isbnService.fetchByIsbn(code);
            if (data != null) {
              setState(() {
                _titleCtrl.text = data['title'] ?? '';
                _authorCtrl.text = data['authors'] ?? '';
                _publisherCtrl.text = data['publisher'] ?? '';
                _pagesCtrl.text = (data['pageCount'] ?? '').toString();
              });
            } else {
              // bulunamadı -> kullanıcı manuel düzenlesin
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ISBN bilgisi bulunamadı.')),
                );
              }
            }
          },
        ),
      ),
    );
    setState(() => _scanning = false);
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Kitap Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Başlık *'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Başlık gerekli' : null,
              ),
              TextFormField(
                controller: _authorCtrl,
                decoration: const InputDecoration(labelText: 'Yazar(lar)'),
              ),
              TextFormField(
                controller: _publisherCtrl,
                decoration: const InputDecoration(labelText: 'Yayınevi'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _isbnCtrl,
                      decoration: const InputDecoration(labelText: 'ISBN'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: _scanning ? null : _scanBarcode,
                    tooltip: 'Barkod Tara',
                  ),
                ],
              ),
              TextFormField(
                controller: _pagesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Sayfa Sayısı'),
              ),
              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                    labelText: 'Raf / Konum (isteğe bağlı)'),
              ),
              TextFormField(
                controller: _tagsCtrl,
                decoration: const InputDecoration(
                  labelText:
                      'Etiketler (virgülle ayırın, örn: roman, kişisel gelişim)',
                ),
              ),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Not'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                child: const Text('Kaydet'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  await prov.addBook(
                    title: _titleCtrl.text,
                    authors: _authorCtrl.text,
                    publisher: _publisherCtrl.text,
                    isbn: _isbnCtrl.text,
                    pageCount:
                        int.tryParse(_pagesCtrl.text.replaceAll(',', '')) ?? 0,
                    location: _locationCtrl.text,
                    tags: _tagsCtrl.text,
                    note: _noteCtrl.text,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
