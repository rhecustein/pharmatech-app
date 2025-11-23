import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionModel>> getPrescriptions({
    PrescriptionStatus? status,
    int page = 1,
    int limit = 20,
  });
  Future<PrescriptionModel> getPrescriptionById(String id);
  Future<PrescriptionModel> uploadPrescription(UploadPrescriptionRequest request);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final DioClient _dioClient;

  PrescriptionRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<PrescriptionModel>> getPrescriptions({
    PrescriptionStatus? status,
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
        ApiConfig.prescriptions,
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data
          .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    try {
      final response = await _dioClient.get('${ApiConfig.prescriptions}/$id');
      return PrescriptionModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PrescriptionModel> uploadPrescription(UploadPrescriptionRequest request) async {
    try {
      final response = await _dioClient.uploadFile(
        ApiConfig.prescriptionUpload,
        request.imagePath,
        fileKey: 'image',
        data: request.toJson(),
      );
      return PrescriptionModel.fromJson(response.data['data'] as Map<String, dynamic>);
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
final prescriptionRemoteDataSourceProvider = Provider<PrescriptionRemoteDataSource>((ref) {
  return PrescriptionRemoteDataSourceImpl(ref.read(dioClientProvider));
});
