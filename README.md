# Evde Kütüphane - Flutter MVP (Android)

Basit bir Android uygulaması için Flutter tabanlı MVP iskeleti. Özellikler:
- Kitap ekleme (manuel + barkod/ISBN tarama)
- Kitap listesi, detay
- Lokal veritabanı: sqflite (SQLite)
- ISBN bilgisi: Open Library API
- Barkod tarama: mobile_scanner (kamera)
- Türkçe arayüz

Kurulum:
1. Flutter SDK kurulu olmalı.
2. Proje kökünde:
   flutter pub get
3. Android tarafında kamera iznini ekleyin: android/app/src/main/AndroidManifest.xml içine aşağıdaki izinleri ekleyin:
   <uses-permission android:name="android.permission.CAMERA" />
4. Uygulamayı çalıştırın:
   flutter run

Notlar:
- Bulut senkronizasyonu için Firebase (Authentication + Firestore) opsiyoneldir; istersen ekleyebilirim.
- ISBN bilgisi Open Library'den çekilir; sonuç bulunamazsa manuel düzenleme yapılabilir.
