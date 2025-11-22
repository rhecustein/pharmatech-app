```markdown
# PharmaTech Mobile - Flutter Mobile Application (Android & iOS)

## 📚 Table of Contents

1. [Project Overview](#project-overview)
2. [Quick Start](#quick-start)
3. [Project Structure](#project-structure)
4. [Features Implementation](#features-implementation)
5. [State Management](#state-management)
6. [API Integration](#api-integration)
7. [Local Database](#local-database)
8. [Push Notifications](#push-notifications)
9. [Offline Support](#offline-support)
10. [Camera & Scanner](#camera--scanner)
11. [Biometric Authentication](#biometric-authentication)
12. [UI/UX Components](#uiux-components)
13. [Testing](#testing)
14. [Build & Deployment](#build--deployment)

---

## 🎯 Project Overview

PharmaTech Mobile adalah aplikasi mobile untuk:
- **Staff Apotek**: POS mobile, stock checking, inventory management
- **Customer**: Browse produk, order online, konsultasi apoteker
- **Pharmacist**: Verifikasi resep, konsultasi customer
- **Owner**: Dashboard analytics, reports

### Tech Stack
- **Framework**: Flutter 3.24+
- **State Management**: Riverpod 2.5+
- **Routing**: Go Router 14+
- **HTTP Client**: Dio 5.4+
- **Local Database**: Drift (SQLite) + Hive
- **Push Notifications**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics
- **Crash Reporting**: Firebase Crashlytics
- **Image**: cached_network_image, image_picker
- **Scanner**: mobile_scanner (barcode/QR)
- **Maps**: google_maps_flutter
- **Biometric**: local_auth

---

## 🚀 Quick Start

### Prerequisites

```bash
# Install Flutter SDK
flutter --version  # Should be 3.24 or higher

# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Check Flutter setup
flutter doctor
```

### Create Project

```bash
# 1. Create Flutter project
flutter create pharmatech_mobile \
  --org com.autobotwijaya.pharmatech \
  --platforms android,ios \
  --project-name pharmatech_mobile

cd pharmatech_mobile

# 2. Initialize Firebase
flutterfire configure

# 3. Add dependencies
flutter pub add riverpod flutter_riverpod riverpod_annotation hooks_riverpod
flutter pub add go_router dio retrofit freezed_annotation json_annotation
flutter pub add drift drift_flutter hive hive_flutter
flutter pub add firebase_core firebase_messaging firebase_analytics firebase_crashlytics
flutter pub add flutter_local_notifications
flutter pub add shared_preferences flutter_secure_storage
flutter pub add cached_network_image flutter_svg image_picker
flutter pub add mobile_scanner qr_flutter
flutter pub add geolocator google_maps_flutter
flutter pub add url_launcher share_plus
flutter pub add intl logger connectivity_plus
flutter pub add shimmer skeleton_text loading_animation_widget
flutter pub add fl_chart syncfusion_flutter_charts
flutter pub add carousel_slider smooth_page_indicator
flutter pub add pull_to_refresh infinite_scroll_pagination
flutter pub add lottie rive flutter_animate
flutter pub add local_auth permission_handler
flutter pub add device_info_plus package_info_plus
flutter pub add flutter_native_splash flutter_launcher_icons

# Dev dependencies
flutter pub add --dev build_runner freezed json_serializable
flutter pub add --dev drift_dev riverpod_generator riverpod_lint
flutter pub add --dev flutter_test integration_test

# 4. Setup launcher icons
flutter pub run flutter_launcher_icons

# 5. Setup splash screen
flutter pub run flutter_native_splash:create

# 6. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 7. Run the app
flutter run
```

---

## 📂 Project Structure

```
pharmatech_mobile/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── env_config.dart
│   │   │   ├── firebase_config.dart
│   │   │   └── theme_config.dart
│   │   │
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_constants.dart
│   │   │   ├── route_constants.dart
│   │   │   └── asset_constants.dart
│   │   │
│   │   ├── di/
│   │   │   └── injection.dart
│   │   │
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   │
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── dio_client.dart
│   │   │   ├── interceptors/
│   │   │   │   ├── auth_interceptor.dart
│   │   │   │   ├── tenant_interceptor.dart
│   │   │   │   ├── logger_interceptor.dart
│   │   │   │   └── retry_interceptor.dart
│   │   │   └── network_info.dart
│   │   │
│   │   ├── database/
│   │   │   ├── drift/
│   │   │   │   ├── app_database.dart
│   │   │   │   ├── daos/
│   │   │   │   └── tables/
│   │   │   ├── hive/
│   │   │   │   ├── hive_service.dart
│   │   │   │   └── boxes/
│   │   │   └── sync_manager.dart
│   │   │
│   │   ├── storage/
│   │   │   ├── local_storage.dart
│   │   │   ├── secure_storage.dart
│   │   │   └── cache_manager.dart
│   │   │
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   ├── route_guards.dart
│   │   │   └── deep_link_handler.dart
│   │   │
│   │   ├── services/
│   │   │   ├── notification_service.dart
│   │   │   ├── location_service.dart
│   │   │   ├── biometric_service.dart
│   │   │   ├── camera_service.dart
│   │   │   ├── analytics_service.dart
│   │   │   └── crashlytics_service.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_dimensions.dart
│   │   │   └── dark_theme.dart
│   │   │
│   │   └── utils/
│   │       ├── date_utils.dart
│   │       ├── currency_utils.dart
│   │       ├── validators.dart
│   │       ├── image_utils.dart
│   │       └── extensions/
│   │           ├── context_extension.dart
│   │           ├── string_extension.dart
│   │           └── number_extension.dart
│   │
│   ├── features/
│   │   ├── splash/
│   │   │   └── presentation/
│   │   │       └── splash_screen.dart
│   │   │
│   │   ├── onboarding/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── onboarding_page.dart
│   │   │       └── widgets/
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   │   └── auth_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   └── login_response_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       └── logout_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   ├── forgot_password_page.dart
│   │   │       │   └── biometric_setup_page.dart
│   │   │       └── widgets/
│   │   │           ├── login_form.dart
│   │   │           └── social_login_buttons.dart
│   │   │
│   │   ├── home/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── home_page.dart
│   │   │       └── widgets/
│   │   │           ├── home_app_bar.dart
│   │   │           ├── search_bar_widget.dart
│   │   │           ├── category_list.dart
│   │   │           ├── banner_carousel.dart
│   │   │           ├── featured_products.dart
│   │   │           └── quick_actions.dart
│   │   │
│   │   ├── products/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   │   ├── product_model.dart
│   │   │   │   │   └── category_model.dart
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── product.dart
│   │   │   │   │   └── category.dart
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── products_provider.dart
│   │   │       │   └── categories_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── products_page.dart
│   │   │       │   ├── product_detail_page.dart
│   │   │       │   ├── search_page.dart
│   │   │       │   └── category_products_page.dart
│   │   │       └── widgets/
│   │   │           ├── product_card.dart
│   │   │           ├── product_list_item.dart
│   │   │           ├── product_filter_sheet.dart
│   │   │           └── product_sort_sheet.dart
│   │   │
│   │   ├── cart/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── cart.dart
│   │   │   │   │   └── cart_item.dart
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── cart_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── cart_page.dart
│   │   │       │   └── checkout_page.dart
│   │   │       └── widgets/
│   │   │           ├── cart_item_card.dart
│   │   │           ├── cart_summary.dart
│   │   │           └── promo_code_input.dart
│   │   │
│   │   ├── orders/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── orders_page.dart
│   │   │       │   ├── order_detail_page.dart
│   │   │       │   └── order_tracking_page.dart
│   │   │       └── widgets/
│   │   │           ├── order_card.dart
│   │   │           ├── order_status_stepper.dart
│   │   │           └── order_timeline.dart
│   │   │
│   │   ├── prescription/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── prescriptions_page.dart
│   │   │       │   ├── prescription_upload_page.dart
│   │   │       │   ├── prescription_scanner_page.dart
│   │   │       │   └── prescription_detail_page.dart
│   │   │       └── widgets/
│   │   │           ├── prescription_card.dart
│   │   │           ├── camera_preview_widget.dart
│   │   │           └── prescription_status_badge.dart
│   │   │
│   │   ├── consultation/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── pharmacist_list_page.dart
│   │   │       │   ├── chat_consultation_page.dart
│   │   │       │   └── video_call_page.dart
│   │   │       └── widgets/
│   │   │           ├── pharmacist_card.dart
│   │   │           ├── chat_bubble.dart
│   │   │           └── quick_questions.dart
│   │   │
│   │   ├── scanner/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── barcode_scanner_page.dart
│   │   │       └── widgets/
│   │   │           ├── scanner_overlay.dart
│   │   │           └── scan_result_sheet.dart
│   │   │
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── profile_page.dart
│   │   │       │   ├── edit_profile_page.dart
│   │   │       │   ├── addresses_page.dart
│   │   │       │   ├── payment_methods_page.dart
│   │   │       │   └── loyalty_page.dart
│   │   │       └── widgets/
│   │   │           ├── profile_header.dart
│   │   │           ├── menu_item_tile.dart
│   │   │           └── loyalty_card.dart
│   │   │
│   │   ├── notifications/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── notifications_page.dart
│   │   │       └── widgets/
│   │   │           └── notification_card.dart
│   │   │
│   │   ├── settings/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── settings_page.dart
│   │   │       │   ├── language_page.dart
│   │   │       │   ├── theme_page.dart
│   │   │       │   └── about_page.dart
│   │   │       └── widgets/
│   │   │
│   │   └── pos_mobile/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── pos_home_page.dart
│   │           │   ├── mobile_checkout_page.dart
│   │           │   └── stock_check_page.dart
│   │           └── widgets/
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── buttons/
│   │   │   │   ├── primary_button.dart
│   │   │   │   ├── secondary_button.dart
│   │   │   │   ├── text_button.dart
│   │   │   │   └── icon_button.dart
│   │   │   ├── inputs/
│   │   │   │   ├── custom_text_field.dart
│   │   │   │   ├── search_field.dart
│   │   │   │   ├── phone_input.dart
│   │   │   │   └── otp_input.dart
│   │   │   ├── cards/
│   │   │   │   ├── product_card.dart
│   │   │   │   ├── stat_card.dart
│   │   │   │   └── info_card.dart
│   │   │   ├── navigation/
│   │   │   │   ├── bottom_nav_bar.dart
│   │   │   │   ├── custom_app_bar.dart
│   │   │   │   └── drawer_menu.dart
│   │   │   ├── dialogs/
│   │   │   │   ├── confirmation_dialog.dart
│   │   │   │   ├── loading_dialog.dart
│   │   │   │   └── error_dialog.dart
│   │   │   ├── sheets/
│   │   │   │   ├── filter_bottom_sheet.dart
│   │   │   │   └── options_bottom_sheet.dart
│   │   │   ├── loading/
│   │   │   │   ├── shimmer_loading.dart
│   │   │   │   ├── skeleton_loader.dart
│   │   │   │   └── circular_loading.dart
│   │   │   └── common/
│   │   │       ├── empty_state.dart
│   │   │       ├── error_widget.dart
│   │   │       ├── cached_image.dart
│   │   │       ├── badge_widget.dart
│   │   │       └── rating_stars.dart
│   │   │
│   │   └── models/
│   │       └── response/
│   │           └── api_response.dart
│   │
│   └── l10n/
│       ├── app_en.arb
│       └── app_id.arb
│
├── android/
│   ├── app/
│   │   ├── src/
│   │   │   └── main/
│   │   │       ├── AndroidManifest.xml
│   │   │       ├── kotlin/
│   │   │       └── res/
│   │   └── build.gradle
│   └── build.gradle
│
├── ios/
│   ├── Runner/
│   │   ├── Info.plist
│   │   ├── AppDelegate.swift
│   │   └── GoogleService-Info.plist
│   └── Podfile
│
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── placeholder.png
│   │   └── onboarding/
│   ├── icons/
│   ├── animations/
│   │   └── lottie/
│   └── fonts/
│
├── test/
├── integration_test/
├── pubspec.yaml
├── analysis_options.yaml
├── flutter_launcher_icons.yaml
├── flutter_native_splash.yaml
└── README.md
```

---

## 🎨 Main Entry Point

### main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/config/firebase_config.dart';
import 'core/services/notification_service.dart';
import 'core/database/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseConfig.currentPlatform,
  );

  // Initialize Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize Hive
  await Hive.initFlutter();
  await HiveService.initialize();

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(
    const ProviderScope(
      child: PharmaTechApp(),
    ),
  );
}
```

### app.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/analytics_service.dart';

class PharmaTechApp extends ConsumerWidget {
  const PharmaTechApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'PharmaTech',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Routing
      routerConfig: router,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      locale: const Locale('id', 'ID'),

      // Analytics
      navigatorObservers: [
        AnalyticsService.observer,
      ],

      // Builder for responsive design
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
```

---

## 🎨 Theme Configuration

### core/theme/app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        background: AppColors.background,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onBackground: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.heading3.copyWith(
          color: AppColors.textPrimary,
        ),
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        headlineMedium: AppTextStyles.heading4,
        titleLarge: AppTextStyles.subtitle1,
        titleMedium: AppTextStyles.subtitle2,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        background: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF1E1E1E),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}

// Theme Mode Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.light;
});
```

### core/theme/app_colors.dart

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color primaryDark = Color(0xFF1976D2);

  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryLight = Color(0xFF81C784);
  static const Color secondaryDark = Color(0xFF388E3C);

  // Accent Colors
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFB74D);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Border & Divider
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);

  // Overlay
  static const Color overlay = Color(0x66000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
```

### core/theme/app_text_styles.dart

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Subtitles
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Body Text
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Overline
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  // Price
  static const TextStyle price = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // Price Small
  static const TextStyle priceSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}
```

---

## 🔐 Authentication Implementation

### features/auth/presentation/pages/login_page.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);
    
    final result = await authNotifier.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    result.when(
      success: (_) {
        context.go('/home');
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  Future<void> _handleBiometricLogin() async {
    final authNotifier = ref.read(authProvider.notifier);
    
    final result = await authNotifier.loginWithBiometric();

    if (!mounted) return;

    result.when(
      success: (_) {
        context.go('/home');
      },
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),

                const SizedBox(height: 40),

                // Title
                Text(
                  'Selamat Datang',
                  style: AppTextStyles.heading1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Masuk ke akun Anda',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'Masukkan email Anda',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Masukkan password Anda',
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Remember Me & Forgot Password
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'Ingat Saya',
                      style: AppTextStyles.body2,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.push('/forgot-password');
                      },
                      child: Text(
                        'Lupa Password?',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Login Button
                PrimaryButton(
                  onPressed: authState.isLoading ? null : _handleLogin,
                  isLoading: authState.isLoading,
                  text: 'Masuk',
                ),

                const SizedBox(height: 16),

                // Biometric Login Button
                OutlinedButton.icon(
                  onPressed: _handleBiometricLogin,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Masuk dengan Biometrik'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Atau masuk dengan',
                        style: AppTextStyles.caption,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Google Sign In
                        },
                        icon: Image.asset(
                          'assets/icons/google.png',
                          height: 24,
                        ),
                        label: const Text('Google'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Apple Sign In
                        },
                        icon: const Icon(Icons.apple),
                        label: const Text('Apple'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: AppTextStyles.body2,
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: Text(
                        'Daftar',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### features/auth/presentation/providers/auth_provider.dart

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/storage/secure_storage.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthState.initial();
  }

  Future<void> _checkAuthStatus() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read('access_token');

    if (token != null) {
      // Validate token and get user data
      // If valid, emit authenticated state
      // If invalid, emit unauthenticated state
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);

    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.when(
      success: (user) {
        state = AuthState.authenticated(user);
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );

    return result;
  }

  Future<Result<User>> loginWithBiometric() async {
    final biometricService = ref.read(biometricServiceProvider);
    final storage = ref.read(secureStorageProvider);

    // Check if biometric is available
    final canAuthenticate = await biometricService.canAuthenticate();
    if (!canAuthenticate) {
      return Result.failure('Biometrik tidak tersedia');
    }

    // Authenticate with biometric
    final authenticated = await biometricService.authenticate(
      reason: 'Login ke PharmaTech',
    );

    if (!authenticated) {
      return Result.failure('Autentikasi biometrik gagal');
    }

    // Get saved credentials
    final email = await storage.read('saved_email');
    final password = await storage.read('saved_password');

    if (email == null || password == null) {
      return Result.failure('Kredensial tidak ditemukan');
    }

    return login(email: email, password: password);
  }

  Future<Result<User>> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true);

    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase(
      RegisterParams(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      ),
    );

    result.when(
      success: (user) {
        state = AuthState.authenticated(user);
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );

    return result;
  }

  Future<void> logout() async {
    final logoutUseCase = ref.read(logoutUseCaseProvider);
    await logoutUseCase(NoParams());

    state = const AuthState.unauthenticated();
  }
}

// Auth State
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  const AuthState.initial()
      : user = null,
        isLoading = false,
        error = null;

  const AuthState.authenticated(this.user)
      : isLoading = false,
        error = null;

  const AuthState.unauthenticated()
      : user = null,
        isLoading = false,
        error = null;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
```

---

## 📱 Home Screen Implementation

### features/home/presentation/pages/home_page.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_list.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/featured_products.dart';
import '../widgets/quick_actions.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load home data
    Future.microtask(() {
      ref.read(homeDataProvider.notifier).loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeDataProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(homeDataProvider.notifier).refresh();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              const SliverToBoxAdapter(
                child: HomeAppBar(),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchBarWidget(
                    onTap: () {
                      context.push('/search');
                    },
                    onScan: () {
                      context.push('/scanner');
                    },
                  ),
                ),
              ),

              // Banner Carousel
              homeData.when(
                data: (data) {
                  return SliverToBoxAdapter(
                    child: BannerCarousel(banners: data.banners),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: BannerCarouselShimmer(),
                ),
                error: (error, _) => const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
              ),

              // Quick Actions
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: QuickActions(),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori',
                        style: AppTextStyles.heading3,
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/categories');
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ),
              ),

              homeData.when(
                data: (data) {
                  return SliverToBoxAdapter(
                    child: CategoryList(categories: data.categories),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: CategoryListShimmer(),
                ),
                error: (error, _) => const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
              ),

              // Featured Products
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Produk Unggulan',
                        style: AppTextStyles.heading3,
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/products');
                        },
                        child: const Text('Lihat Semua'),
                      ),
                    ],
                  ),
                ),
              ),

              homeData.when(
                data: (data) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: FeaturedProducts(products: data.featuredProducts),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: FeaturedProductsShimmer(),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: $error'),
                  ),
                ),
              ),

              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🛒 Shopping Cart Implementation

### features/cart/presentation/providers/cart_provider.dart

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../../../core/database/hive/boxes/cart_box.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  Future<Cart> build() async {
    return _loadCart();
  }

  Future<Cart> _loadCart() async {
    final cartBox = ref.read(cartBoxProvider);
    final items = await cartBox.getAllItems();
    return Cart(items: items);
  }

  Future<void> addProduct(Product product, {int quantity = 1}) async {
    final currentState = await future;
    
    // Check if product already in cart
    final existingItem = currentState.items.firstWhereOrNull(
      (item) => item.productId == product.id,
    );

    if (existingItem != null) {
      // Update quantity
      await updateQuantity(
        existingItem.id,
        existingItem.quantity + quantity,
      );
    } else {
      // Add new item
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        price: product.sellingPrice,
        quantity: quantity,
        subtotal: product.sellingPrice * quantity,
      );

      final addUseCase = ref.read(addToCartUseCaseProvider);
      await addUseCase(AddToCartParams(item: cartItem));

      state = AsyncData(
        currentState.copyWith(
          items: [...currentState.items, cartItem],
        ),
      );
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(itemId);
      return;
    }

    final currentState = await future;
    final updatedItems = currentState.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(
          quantity: quantity,
          subtotal: item.price * quantity,
        );
      }
      return item;
    }).toList();

    final updateUseCase = ref.read(updateCartItemUseCaseProvider);
    final updatedItem = updatedItems.firstWhere((item) => item.id == itemId);
    await updateUseCase(UpdateCartItemParams(item: updatedItem));

    state = AsyncData(
      currentState.copyWith(items: updatedItems),
    );
  }

  Future<void> incrementQuantity(String itemId) async {
    final currentState = await future;
    final item = currentState.items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity + 1);
  }

  Future<void> decrementQuantity(String itemId) async {
    final currentState = await future;
    final item = currentState.items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity - 1);
  }

  Future<void> removeItem(String itemId) async {
    final currentState = await future;
    
    final removeUseCase = ref.read(removeFromCartUseCaseProvider);
    await removeUseCase(RemoveFromCartParams(itemId: itemId));

    state = AsyncData(
      currentState.copyWith(
        items: currentState.items.where((item) => item.id != itemId).toList(),
      ),
    );
  }

  Future<void> clear() async {
    final clearUseCase = ref.read(clearCartUseCaseProvider);
    await clearUseCase(NoParams());

    state = const AsyncData(Cart(items: []));
  }

  Future<void> applyPromoCode(String code) async {
    // Validate promo code
    // Apply discount
  }

  int get itemCount {
    return state.when(
      data: (cart) => cart.items.fold(0, (sum, item) => sum + item.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  double get totalAmount {
    return state.when(
      data: (cart) => cart.total,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }
}

// Cart item count provider for badge
@riverpod
int cartItemCount(CartItemCountRef ref) {
  return ref.watch(cartNotifierProvider.select((cart) {
    return cart.when(
      data: (cart) => cart.items.fold(0, (sum, item) => sum + item.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );
  }));
}
```

---