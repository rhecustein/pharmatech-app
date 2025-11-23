import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/consultation_model.dart';

abstract class ConsultationRemoteDataSource {
  Future<List<PharmacistModel>> getPharmacists({
    PharmacistStatus? status,
    int page = 1,
    int limit = 20,
  });
  Future<ConsultationSessionModel> startConsultation(StartConsultationRequest request);
  Future<ConsultationSessionModel> getConsultationSession(String id);
  Future<List<ConsultationSessionModel>> getConsultationHistory({int page = 1, int limit = 20});
  Future<ChatMessageModel> sendMessage(SendMessageRequest request);
  Future<List<ChatMessageModel>> getMessages(String sessionId, {int page = 1, int limit = 50});
  Future<void> endConsultation(String sessionId);
}

class ConsultationRemoteDataSourceImpl implements ConsultationRemoteDataSource {
  final DioClient _dioClient;

  ConsultationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<PharmacistModel>> getPharmacists({
    PharmacistStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.toString().split('.').last,
      };

      final response = await _dioClient.get(
        ApiConfig.pharmacists,
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => PharmacistModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ConsultationSessionModel> startConsultation(StartConsultationRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.consultation,
        data: request.toJson(),
      );
      return ConsultationSessionModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ConsultationSessionModel> getConsultationSession(String id) async {
    try {
      final response = await _dioClient.get('${ApiConfig.consultation}/$id');
      return ConsultationSessionModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ConsultationSessionModel>> getConsultationHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiConfig.consultation}/history',
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => ConsultationSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(SendMessageRequest request) async {
    try {
      Response response;

      if (request.filePath != null) {
        // Upload file message
        response = await _dioClient.uploadFile(
          '${ApiConfig.chat}/send',
          request.filePath!,
          fileKey: 'file',
          data: request.toJson(),
        );
      } else {
        // Text message
        response = await _dioClient.post(
          '${ApiConfig.chat}/send',
          data: request.toJson(),
        );
      }

      return ChatMessageModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(
    String sessionId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiConfig.chat}/$sessionId/messages',
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> endConsultation(String sessionId) async {
    try {
      await _dioClient.post('${ApiConfig.consultation}/$sessionId/end');
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
final consultationRemoteDataSourceProvider = Provider<ConsultationRemoteDataSource>((ref) {
  return ConsultationRemoteDataSourceImpl(ref.read(dioClientProvider));
});
