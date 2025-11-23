import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20});
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<int> getUnreadCount();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient _dioClient;

  NotificationsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20}) async {
    try {
      final response = await _dioClient.get(
        ApiConfig.notifications,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _dioClient.post('${ApiConfig.notifications}/$id/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _dioClient.post('${ApiConfig.notifications}/read-all');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _dioClient.delete('${ApiConfig.notifications}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _dioClient.get('${ApiConfig.notifications}/unread-count');
      return response.data['data']['count'] as int;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'] as String;
      }
    }
    return e.message ?? 'An error occurred';
  }
}

// Provider
final notificationsRemoteDataSourceProvider = Provider<NotificationsRemoteDataSource>((ref) {
  return NotificationsRemoteDataSourceImpl(ref.read(dioClientProvider));
});
