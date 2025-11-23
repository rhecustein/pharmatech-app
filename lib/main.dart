import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/local_cache_service.dart';
import 'core/services/notification_service.dart';

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

  // Create provider container for initialization
  final container = ProviderContainer();

  // Initialize Local Cache (Hive)
  final cacheService = container.read(localCacheServiceProvider);
  await cacheService.init();

  // Initialize Notifications
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.init();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp(
  //   options: FirebaseConfig.currentPlatform,
  // );

  // TODO: Initialize Firebase Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // TODO: Initialize Firebase Messaging
  // final messaging = FirebaseMessaging.instance;
  // await messaging.requestPermission();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PharmaTechApp(),
    ),
  );
}
