import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(Map<String, dynamic> data);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.login,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data['data']);

      // Save tokens to local storage
      final box = await Hive.openBox('auth');
      await box.put(ApiConfig.accessTokenKey, authResponse.accessToken);
      await box.put(ApiConfig.refreshTokenKey, authResponse.refreshToken);
      await box.put(ApiConfig.userKey, authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data['data']);

      // Save tokens to local storage
      final box = await Hive.openBox('auth');
      await box.put(ApiConfig.accessTokenKey, authResponse.accessToken);
      await box.put(ApiConfig.refreshTokenKey, authResponse.refreshToken);
      await box.put(ApiConfig.userKey, authResponse.user.toJson());

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiConfig.logout);

      // Clear local storage
      final box = await Hive.openBox('auth');
      await box.clear();
    } on DioException catch (e) {
      // Even if API call fails, clear local storage
      final box = await Hive.openBox('auth');
      await box.clear();
      throw _handleError(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dioClient.post(
        ApiConfig.forgotPassword,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.get(ApiConfig.profile);
      final user = UserModel.fromJson(response.data['data']);

      // Update local storage
      final box = await Hive.openBox('auth');
      await box.put(ApiConfig.userKey, user.toJson());

      return user;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put(
        ApiConfig.profile,
        data: data,
      );

      final user = UserModel.fromJson(response.data['data']);

      // Update local storage
      final box = await Hive.openBox('auth');
      await box.put(ApiConfig.userKey, user.toJson());

      return user;
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
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioClientProvider));
});
