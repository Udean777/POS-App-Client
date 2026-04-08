# Modal POS - Client (Flutter)

Aplikasi Point of Sale (POS) modern yang dibangun menggunakan Flutter, dirancang untuk kecepatan, kemudahan penggunaan, dan manajemen bisnis yang efisien.

## 🚀 Tech Stack

Aplikasi ini menggunakan teknologi terbaru dalam ekosistem Flutter untuk memastikan performa dan maintainability:

- **Framework**: [Flutter](https://flutter.dev/) (Target: Android & iOS)
- **State Management**: [Riverpod](https://riverpod.dev/) (dengan Code Generation)
- **Dependency Injection**: Riverpod
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Networking**: [Dio](https://pub.dev/packages/dio) (dengan Interceptors untuk Auth)
- **Data Modeling**: [Freezed](https://pub.dev/packages/freezed) & [JSON Serializable](https://pub.dev/packages/json_serializable)
- **Penyimpanan Lokal**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- **UI & Grafik**:
  - [Google Fonts](https://pub.dev/packages/google_fonts)
  - [FL Chart](https://pub.dev/packages/fl_chart) (Analitik & Statistik)
  - [Toastification](https://pub.dev/packages/toastification) (Notifikasi yang cantik)
  - [Cached Network Image](https://pub.dev/packages/cached_network_image)
- **Functional Programming**: [Fpdart](https://pub.dev/packages/fpdart)

## ✨ Fitur Utama

1.  **Dashboard**: Visualisasi statistik penjualan dan ringkasan data bisnis secara real-time.
2.  **Point of Sale (POS)**: Antarmuka transaksi yang cepat dengan dukungan pencarian produk dan manajemen keranjang.
3.  **Manajemen Produk**: Kelola katalog produk, stok, kategori, dan harga dengan mudah.
4.  **Riwayat Transaksi**: Lacak semua transaksi yang telah selesai dengan detail item dan metode pembayaran.
5.  **Manajemen Staff**: Kelola akun karyawan dan hak akses di dalam sistem.
6.  **Profil Bisnis**: Sesuaikan informasi toko dan pengaturan aplikasi.
7.  **Autentikasi Aman**: Login dan registrasi menggunakan JWT yang disimpan secara aman di storage perangkat.
8.  **Forgot Password**: Kemudahan memulihkan akun bagi Owner via OTP dan bagi Staff melalui sistem ajuan ke Owner.

## 🏗️ Arsitektur Proyek

Proyek ini mengikuti prinsip **Clean Architecture** dengan pendekatan berbasis Fitur (**Feature-based structure**):

```text
lib/
├── core/             # Logika bersama, konstanta, utils, dan network config
│   ├── constants/
│   ├── network/      # Dio client & Interceptors
│   └── presentation/ # Komponen UI global (tema, widget umum)
├── features/         # Setiap fitur memiliki foldernya sendiri
│   ├── auth/         # Contoh: Data, Domain, Presentation layers
│   ├── dashboard/
│   ├── products/
│   └── transaction/
└── src/              # Konfigurasi entry-point, router, dan theme global
```

## 🛠️ Cara Menjalankan

### Persiapan

1. Pastikan Flutter SDK sudah terinstal (Versi ^3.11.4).
2. Clone repository dan masuk ke direktori `client`.
3. Jalankan perintah untuk mengambil dependensi:
   ```bash
   flutter pub get
   ```

### Code Generation

Karena aplikasi ini menggunakan `freezed` dan `riverpod_generator`, Anda perlu menjalankan build runner:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Menjalankan Aplikasi

Pilih perangkat target (Emulator Android atau Simulator iOS) dan jalankan:

```bash
flutter run
```

---

> [!NOTE]
> Alamat API dikonfigurasi secara dinamis di `lib/core/constants/app_constants.dart`. Secara default, aplikasi mengarah ke `localhost:8080` (atau `10.0.2.2` untuk emulator Android).
