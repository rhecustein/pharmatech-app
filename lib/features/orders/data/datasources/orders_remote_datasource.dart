import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders({OrderStatus? status, int page = 1, int limit = 20});
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> createOrder(CreateOrderRequest request);
  Future<void> cancelOrder(String id);
  Future<List<TrackingEventModel>> getOrderTracking(String orderId);
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> createAddress(Map<String, dynamic> data);
  Future<AddressModel> updateAddress(String id, Map<String, dynamic> data);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final DioClient _dioClient;

  OrdersRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<OrderModel>> getOrders({OrderStatus? status, int page = 1, int limit = 20}) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.toString().split('.').last,
      };

      final response = await _dioClient.get(
        ApiConfig.orders,
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    try {
      final response = await _dioClient.get('${ApiConfig.orders}/$id');
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<OrderModel> createOrder(CreateOrderRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.orders,
        data: request.toJson(),
      );
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> cancelOrder(String id) async {
    try {
      await _dioClient.post('${ApiConfig.orders}/$id/cancel');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<TrackingEventModel>> getOrderTracking(String orderId) async {
    try {
      final response = await _dioClient.get('${ApiConfig.orderTracking}/$orderId');
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => TrackingEventModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await _dioClient.get(ApiConfig.addresses);
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AddressModel> createAddress(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post(ApiConfig.addresses, data: data);
      return AddressModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<AddressModel> updateAddress(String id, Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.put('${ApiConfig.addresses}/$id', data: data);
      return AddressModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await _dioClient.delete('${ApiConfig.addresses}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    try {
      await _dioClient.post('${ApiConfig.addresses}/$id/set-default');
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
final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  return OrdersRemoteDataSourceImpl(ref.read(dioClientProvider));
});
