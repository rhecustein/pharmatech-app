import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalCacheService {
  // Box names
  static const String authBox = 'auth';
  static const String userBox = 'user';
  static const String productsBox = 'products';
  static const String cartBox = 'cart';
  static const String ordersBox = 'orders';
  static const String prescriptionsBox = 'prescriptions';
  static const String notificationsBox = 'notifications';
  static const String settingsBox = 'settings';

  // Initialize Hive and register adapters
  Future<void> init() async {
    await Hive.initFlutter();

    // Register type adapters here after generating them
    // Example:
    // Hive.registerAdapter(UserModelAdapter());
    // Hive.registerAdapter(ProductModelAdapter());
    // Hive.registerAdapter(CartItemModelAdapter());
    // Hive.registerAdapter(OrderModelAdapter());
    // etc.

    // Open frequently used boxes
    await openBox(authBox);
    await openBox(settingsBox);
  }

  // Open a box
  Future<Box> openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  // Get a box
  Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  // Save data to box
  Future<void> save(String boxName, String key, dynamic value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  // Get data from box
  dynamic get(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  // Delete data from box
  Future<void> delete(String boxName, String key) async {
    final box = await openBox(boxName);
    await box.delete(key);
  }

  // Clear box
  Future<void> clearBox(String boxName) async {
    final box = await openBox(boxName);
    await box.clear();
  }

  // Clear all boxes
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
    await init();
  }

  // Close box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  // Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
  }

  // Check if key exists
  bool has(String boxName, String key) {
    final box = Hive.box(boxName);
    return box.containsKey(key);
  }

  // Get all keys in box
  Iterable<dynamic> getKeys(String boxName) {
    final box = Hive.box(boxName);
    return box.keys;
  }

  // Get all values in box
  Iterable<dynamic> getValues(String boxName) {
    final box = Hive.box(boxName);
    return box.values;
  }

  // Cache with expiration
  Future<void> cacheWithExpiration({
    required String boxName,
    required String key,
    required dynamic value,
    required Duration expiration,
  }) async {
    final box = await openBox(boxName);
    final expirationTime = DateTime.now().add(expiration).millisecondsSinceEpoch;

    await box.put(key, {
      'value': value,
      'expiration': expirationTime,
    });
  }

  // Get cached data with expiration check
  dynamic getCached(String boxName, String key) {
    try {
      final box = Hive.box(boxName);
      final data = box.get(key);

      if (data == null) return null;

      if (data is Map) {
        final expiration = data['expiration'] as int?;
        if (expiration != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          if (now > expiration) {
            // Cache expired, delete it
            box.delete(key);
            return null;
          }
        }
        return data['value'];
      }

      return data;
    } catch (e) {
      print('Error getting cached data: $e');
      return null;
    }
  }

  // Clear expired cache entries
  Future<void> clearExpiredCache(String boxName) async {
    try {
      final box = await openBox(boxName);
      final now = DateTime.now().millisecondsSinceEpoch;
      final keysToDelete = <dynamic>[];

      for (var key in box.keys) {
        final data = box.get(key);
        if (data is Map && data.containsKey('expiration')) {
          final expiration = data['expiration'] as int;
          if (now > expiration) {
            keysToDelete.add(key);
          }
        }
      }

      for (var key in keysToDelete) {
        await box.delete(key);
      }
    } catch (e) {
      print('Error clearing expired cache: $e');
    }
  }
}

// Provider
final localCacheServiceProvider = Provider<LocalCacheService>((ref) {
  return LocalCacheService();
});

// Initialize cache on app start
final cacheInitializerProvider = FutureProvider<void>((ref) async {
  final cacheService = ref.read(localCacheServiceProvider);
  await cacheService.init();
});
