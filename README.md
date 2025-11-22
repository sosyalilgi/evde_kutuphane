# Evde Kütüphane

Bu proje hem **Flutter mobil uygulama** hem de **Web arayüzü** içerir.

## 🌐 Web Arayüzü (Node.js/Express)

Modern, responsive bir web arayüzü ile kitap yönetimi.

### Kurulum ve Çalıştırma

1. **Node.js kurulumu**: Node.js 14.0.0 veya üzeri gereklidir.
   ```bash
   node --version
   ```

2. **Bağımlılıkları yükleyin**:
   ```bash
   npm install
   ```

3. **Sunucuyu başlatın**:
   ```bash
   npm start
   ```

4. **Tarayıcıda açın**:
   ```
   http://localhost:3000
   ```

### Web Arayüzü Özellikleri

- ✅ Bootstrap 5 ile modern, responsive tasarım
- ✅ Kitap ekleme formu (başlık, yazar, notlar)
- ✅ Gerçek zamanlı form validasyonu
- ✅ Loading state gösterimi
- ✅ Başarı/hata bildirimleri
- ✅ Kalıcı JSON depolama (data/books.json)
- ✅ RESTful API (/api/save, /api/books)

### Proje Yapısı (Web)

```
public/                    # Web arayüzü dosyaları
├── index.html            # Ana sayfa (kitap ekleme formu)
├── css/
│   └── style.css         # Modern stil dosyası
└── js/
    └── save.js           # Form işleme ve API iletişimi
server/
└── server.js             # Express sunucusu
data/
└── books.json            # Kitap veritabanı (JSON)
package.json              # Node.js bağımlılıkları
```

---

## 📱 Flutter Mobil Uygulama (Android)

Basit bir Android uygulaması için Flutter tabanlı MVP iskeleti. Özellikler:
- Kitap ekleme (manuel + barkod/ISBN tarama)
- Kitap listesi, detay, arama
- Lokal veritabanı: sqflite (SQLite)
- ISBN bilgisi: Open Library API
- Barkod tarama: mobile_scanner (kamera)
- Türkçe arayüz

### Gereksinimler
- Flutter SDK 3.0.0 veya üzeri
- Android SDK (API 21+)
- Kotlin desteği

### Kurulum

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

### Teknik Detaylar

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

### Özellikler

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

### Notlar
- Bulut senkronizasyonu için Firebase (Authentication + Firestore) eklenebilir.
- ISBN bilgisi Open Library'den çekilir; sonuç bulunamazsa manuel düzenleme yapılabilir.
- Kamera izni kullanıcı tarafından manuel olarak verilmelidir.
