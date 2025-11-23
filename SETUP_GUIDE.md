# PharmaTech Mobile - Setup Guide

## ✅ What Has Been Completed

Project PharmaTech Mobile telah berhasil disetup dengan komponen-komponen berikut:

### 1. **Project Structure** ✓
```
pharmatech_mobile/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── app.dart                  # Root app widget
│   │
│   ├── core/                     # Core functionality
│   │   ├── config/              # Konfigurasi (app, env, firebase)
│   │   ├── constants/           # Constants (API, routes)
│   │   ├── theme/               # Theme (colors, text styles, theme)
│   │   ├── utils/               # Utilities & extensions
│   │   └── router/              # GoRouter configuration
│   │
│   ├── features/                # Feature modules
│   │   ├── splash/              # Splash screen
│   │   ├── auth/                # Login & Register
│   │   └── home/                # Home page
│   │
│   └── shared/                  # Shared widgets
│       └── widgets/             # Reusable widgets
│
├── assets/                      # Asset files
│   ├── images/
│   ├── icons/
│   └── animations/
│
└── pubspec.yaml                 # Dependencies
```

### 2. **Dependencies** ✓
Semua dependencies sudah ditambahkan ke `pubspec.yaml`:
- State Management: Riverpod
- Routing: GoRouter
- HTTP Client: Dio, Retrofit
- Local Database: Drift, Hive
- Firebase: Core, Messaging, Analytics, Crashlytics
- UI Components: Loading animations, Charts, Carousel, dll
- Utils: Intl, Logger, Connectivity

### 3. **Core Files** ✓

#### Theme System
- ✅ `app_colors.dart` - Color palette
- ✅ `app_text_styles.dart` - Typography
- ✅ `app_theme.dart` - Light & Dark theme

#### Configuration
- ✅ `app_config.dart` - App configuration
- ✅ `env_config.dart` - Environment settings
- ✅ `firebase_config.dart` - Firebase configuration

#### Utilities
- ✅ `validators.dart` - Form validators
- ✅ `context_extension.dart` - BuildContext extensions
- ✅ `string_extension.dart` - String extensions
- ✅ `number_extension.dart` - Number formatting

#### Routing
- ✅ `app_router.dart` - GoRouter setup

### 4. **Features** ✓

#### Splash Screen
- ✅ SplashScreen dengan auto-navigation

#### Authentication
- ✅ LoginPage - Form login dengan validasi
- ✅ RegisterPage - Form registrasi dengan validasi

#### Home
- ✅ HomePage - Main home screen dengan:
  - Search bar
  - Banner carousel placeholder
  - Quick actions
  - Categories
  - Featured products
  - Bottom navigation bar

### 5. **Shared Widgets** ✓
- ✅ `PrimaryButton` - Button dengan loading state
- ✅ `CustomTextField` - Text field dengan validasi
- ✅ `CircularLoading` - Loading indicator
- ✅ `EmptyState` - Empty state widget

---

## 🚀 Next Steps - Langkah Selanjutnya

### Step 1: Install Dependencies

```bash
cd pharmatech_mobile
flutter pub get
```

### Step 2: Setup Firebase (Opsional untuk MVP)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Configure FlutterFire
flutterfire configure
```

Jika belum siap setup Firebase, Anda bisa comment dulu kode Firebase di `main.dart`.

### Step 3: Add Assets

Tambahkan file berikut ke folder `assets/`:

1. **Logo** (`assets/images/logo.png`) - Logo aplikasi 512x512px
2. **Placeholder** (`assets/images/placeholder.png`) - Placeholder image
3. **Icons** (opsional) - Icon tambahan jika diperlukan

Atau buat placeholder sederhana menggunakan Flutter Icon sementara.

### Step 4: Run Code Generation (Jika diperlukan)

Untuk fitur yang menggunakan code generation (Freezed, Riverpod Generator):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 5: Test Run

```bash
# Check for any issues
flutter doctor

# Run the app
flutter run
```

---

## 📱 Fitur yang Sudah Siap

### ✅ Ready to Use
1. **Splash Screen** - Auto-redirect ke login setelah 2 detik
2. **Login Page** - Email & password validation
3. **Register Page** - Full registration form dengan validasi
4. **Home Page** - Layout lengkap dengan placeholders

### 🔄 Navigation Flow
```
Splash Screen → Login Page ↔ Register Page → Home Page
```

### 🎨 Theme
- Light theme (aktif)
- Dark theme (tersedia, bisa diaktifkan)
- Responsive design
- Material 3 design system

---

## 🛠️ Development Tips

### 1. Firebase Setup (Jika tidak siap)

Comment kode berikut di `lib/main.dart`:

```dart
// TODO: Initialize Firebase
// await Firebase.initializeApp(
//   options: FirebaseConfig.currentPlatform,
// );

// TODO: Initialize Firebase Crashlytics
// FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

### 2. Update Firebase Config

Edit `lib/core/config/firebase_config.dart` dengan kredensial Firebase Anda.

### 3. API Integration

Untuk integrasi API, update:
- `lib/core/config/env_config.dart` - Base URL
- `lib/core/constants/api_constants.dart` - API endpoints

### 4. Add More Features

Struktur folder sudah siap untuk fitur tambahan:
- Products
- Cart
- Orders
- Prescriptions
- Consultation
- Profile
- Settings

---

## 🎯 Features to Implement Next

### Priority 1 - Core Features
1. ✅ Authentication (Login/Register) - **DONE**
2. ⏳ Product Listing
3. ⏳ Product Detail
4. ⏳ Shopping Cart
5. ⏳ Checkout

### Priority 2 - Additional Features
6. ⏳ Order Management
7. ⏳ Prescription Upload
8. ⏳ User Profile
9. ⏳ Search & Filter
10. ⏳ Payment Integration

### Priority 3 - Advanced Features
11. ⏳ Push Notifications
12. ⏳ Offline Support
13. ⏳ Biometric Login
14. ⏳ Barcode Scanner
15. ⏳ Analytics

---

## 📚 Code Examples

### Using Custom Widgets

```dart
// Primary Button
PrimaryButton(
  onPressed: () => _handleSubmit(),
  text: 'Submit',
  isLoading: _isLoading,
)

// Text Field
CustomTextField(
  controller: _emailController,
  label: 'Email',
  hintText: 'Enter your email',
  validator: Validators.email,
  prefixIcon: Icon(Icons.email),
)
```

### Navigation

```dart
// Navigate to route
context.go(RouteConstants.home);

// Navigate with push
context.push(RouteConstants.productDetail);

// Go back
context.pop();
```

### Using Extensions

```dart
// Context extensions
context.showSnackBar('Success!');
context.showErrorSnackBar('Error occurred');
context.screenWidth; // Get screen width

// String extensions
'john@example.com'.isValidEmail; // true
'Rp 100000'.currencyFormat;

// Number extensions
50000.currencyFormat; // 'Rp 50.000'
```

---

## 🐛 Common Issues & Solutions

### Issue 1: Flutter command not found
**Solution:** Install Flutter SDK dari https://flutter.dev/docs/get-started/install

### Issue 2: Dependencies conflict
**Solution:**
```bash
flutter pub upgrade
flutter pub get
```

### Issue 3: Build errors
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 4: Firebase not configured
**Solution:** Comment Firebase code di main.dart sampai siap setup

---

## 📞 Support

Jika menemui masalah:
1. Check Flutter doctor: `flutter doctor`
2. Clean project: `flutter clean`
3. Review error messages di console
4. Check README.md untuk referensi lengkap

---

## 🎉 Congratulations!

Project PharmaTech Mobile sudah siap untuk development lebih lanjut!

**Next:** Run `flutter pub get` dan `flutter run` untuk melihat aplikasi berjalan.

Happy Coding! 🚀
