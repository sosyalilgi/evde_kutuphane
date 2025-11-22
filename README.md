# Evde Kütüphane - Flutter MVP (Android) + Web Arayüzü

Basit bir Android uygulaması için Flutter tabanlı MVP iskeleti ve alternatif web arayüzü. Özellikler:
- Kitap ekleme (manuel + barkod/ISBN tarama)
- Kitap listesi, detay, arama
- Lokal veritabanı: sqflite (SQLite)
- ISBN bilgisi: Open Library API
- Barkod tarama: mobile_scanner (kamera)
- Türkçe arayüz

## İki Kullanım Seçeneği

Bu proje iki farklı şekilde kullanılabilir:

### 1. Flutter Android Uygulaması (Ana Proje)
Mobil cihazlar için Flutter tabanlı Android uygulaması

### 2. Web Arayüzü (Alternatif)
Masaüstü ve mobil tarayıcılar için Node.js/Express tabanlı web uygulaması

---

## Flutter Android Uygulaması

### Gereksinimler
- Flutter SDK 3.0.0 veya üzeri
- Android SDK (API 21+)
- Kotlin desteği

## Kurulum

1. **Flutter SDK kurulumu**: Flutter SDK'nın kurulu olduğundan emin olun.
   ```bash
   flutter --version
   ```

2. **Bağımlılıkları yükleyin**:
   ```bash
   flutter pub get
   ```

3. **Uygulamayı çalıştırın**:
   ```bash
   flutter run
   ```

4. **APK oluşturun**:
   ```bash
   flutter build apk
   ```

## Teknik Detaylar

### Android Yapılandırması
- **Android Embedding**: V2 (FlutterActivity)
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34
- **Gradle**: 8.3
- **Kotlin**: 1.9.0

### İzinler
Kamera izni AndroidManifest.xml'de tanımlanmıştır:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### Bağımlılıklar
- `provider` ^6.1.2: State management
- `sqflite` ^2.3.3+1: SQLite veritabanı
- `http` ^1.2.2: HTTP istekleri (ISBN API)
- `mobile_scanner` ^5.2.3: Barkod/QR kod tarama
- `uuid` ^4.5.1: Benzersiz ID oluşturma
- `path` ^1.9.0: Dosya yolu yardımcıları
- `cupertino_icons` ^1.0.8: iOS stil iconlar
- `flutter_lints` ^5.0.0 (dev): Kod kalitesi analizi

### Proje Yapısı
```
lib/
├── main.dart              # Uygulama giriş noktası
├── models/
│   └── book.dart          # Kitap veri modeli
├── pages/
│   ├── book_list_page.dart    # Ana liste sayfası
│   ├── add_book_page.dart     # Kitap ekleme sayfası
│   └── book_detail_page.dart  # Kitap detay sayfası
├── providers/
│   └── book_provider.dart     # State management
└── services/
    ├── db_service.dart        # SQLite veritabanı servisi
    └── isbn_service.dart      # Open Library API servisi
```

## Özellikler

### Kitap Yönetimi
- ✅ Kitap ekleme (manuel ve barkod ile)
- ✅ Kitap listesi görüntüleme
- ✅ Kitap detaylarını görüntüleme ve düzenleme
- ✅ Kitap silme
- ✅ Kitap arama (başlık, yazar, etiket, ISBN)

### ISBN Desteği
- ISBN numarası ile Open Library API'den otomatik kitap bilgisi çekme
- Başlık, yazar, yayınevi, sayfa sayısı gibi bilgilerin otomatik doldurulması

### Barkod Tarama
- mobile_scanner ile barkod/ISBN tarama
- Tarama sonrası otomatik bilgi çekme

## Notlar
- Bulut senkronizasyonu için Firebase (Authentication + Firestore) eklenebilir.
- ISBN bilgisi Open Library'den çekilir; sonuç bulunamazsa manuel düzenleme yapılabilir.
- Kamera izni kullanıcı tarafından manuel olarak verilmelidir.

---

## Web Arayüzü (Alternatif Kullanım)

Web arayüzü, masaüstü ve mobil tarayıcılar için basit bir kitap ekleme arayüzü sağlar.

### Özellikler
- ✅ Modern ve responsive Bootstrap 5 arayüzü
- ✅ Kitap ekleme formu (başlık, yazar, yayınevi, ISBN, vb.)
- ✅ JSON tabanlı veri depolama (data/books.json)
- ✅ Express.js backend API
- ✅ Gerçek zamanlı form doğrulama
- ✅ Başarı/hata mesajları

### Gereksinimler
- Node.js 14.0.0 veya üzeri
- npm (Node Package Manager)

### Kurulum ve Çalıştırma

1. **Bağımlılıkları yükleyin**:
   ```bash
   npm install
   ```

2. **Web sunucusunu başlatın**:
   ```bash
   npm start
   ```

3. **Tarayıcıda açın**:
   ```
   http://localhost:3000
   ```

### API Endpoint'leri

#### POST /api/save
Yeni kitap ekler.

**Request Body**:
```json
{
  "title": "Kitap Başlığı",
  "author": "Yazar Adı",
  "publisher": "Yayınevi",
  "isbn": "978-xxx",
  "pageCount": 250,
  "location": "Raf 1",
  "tags": "roman, kurgu",
  "note": "Notlar"
}
```

**Response (Başarılı)**:
```json
{
  "success": true,
  "message": "Kitap başarıyla kaydedildi",
  "book": { ... }
}
```

#### GET /api/books
Tüm kitapları listeler.

**Response**:
```json
{
  "success": true,
  "books": [ ... ]
}
```

### Dosya Yapısı

```
.
├── public/              # Frontend dosyaları
│   ├── index.html       # Ana sayfa
│   ├── css/
│   │   └── style.css    # Özel stiller
│   └── js/
│       └── save.js      # Form işlemleri ve API çağrıları
├── server/              # Backend
│   └── server.js        # Express sunucu
├── data/                # Veri depolama
│   └── books.json       # Kitap verileri (JSON)
├── package.json         # Node.js bağımlılıkları
└── README.md           # Bu dosya
```

### Veri Depolama

Kitaplar `data/books.json` dosyasında saklanır. Bu dosya sunucu ilk çalıştırıldığında otomatik olarak oluşturulur. 

**Örnek veri formatı**:
```json
[
  {
    "id": "unique-id",
    "title": "Örnek Kitap",
    "author": "Yazar Adı",
    "publisher": "Yayınevi",
    "isbn": "978-xxx",
    "pageCount": 250,
    "location": "Raf 1",
    "tags": "roman, kurgu",
    "note": "Notlar",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
]
```

### Production Notları

⚠️ **Önemli**: Bu web arayüzü demo amaçlıdır ve JSON dosya tabanlı basit depolama kullanır.

Production ortamı için öneriler:
- SQLite, PostgreSQL veya MySQL gibi bir veritabanı kullanın
- Kimlik doğrulama ekleyin
- HTTPS kullanın
- Rate limiting ve güvenlik önlemleri ekleyin
- Dosya yükleme boyut limitleri belirleyin
