import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import '../../data/models/notification_model.dart';

// Notifications State
class NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<NotificationModel> get readNotifications =>
      notifications.where((n) => n.isRead).toList();
}

// Notifications Notifier
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsRemoteDataSource _dataSource;

  NotificationsNotifier(this._dataSource) : super(NotificationsState()) {
    getNotifications();
    getUnreadCount();
  }

  // Get notifications
  Future<void> getNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final notifications = await _dataSource.getNotifications();
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Get unread count
  Future<void> getUnreadCount() async {
    try {
      final count = await _dataSource.getUnreadCount();
      state = state.copyWith(unreadCount: count);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Mark as read
  Future<void> markAsRead(String id) async {
    try {
      await _dataSource.markAsRead(id);

      // Update local state
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      final newUnreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _dataSource.markAllAsRead();

      // Update local state
      final updatedNotifications = state.notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Delete notification
  Future<void> deleteNotification(String id) async {
    try {
      await _dataSource.deleteNotification(id);

      // Update local state
      final updatedNotifications =
          state.notifications.where((notification) => notification.id != id).toList();
      final newUnreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Refresh notifications
  Future<void> refresh() async {
    await getNotifications();
    await getUnreadCount();
  }
}

// Provider
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(ref.read(notificationsRemoteDataSourceProvider));
});

// Convenience providers
final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});

final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationsProvider).unreadCount > 0;
});
