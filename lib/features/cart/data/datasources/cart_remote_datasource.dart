import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<CartItemModel> addToCart(AddToCartRequest request);
  Future<CartItemModel> updateCartItem(String id, UpdateCartItemRequest request);
  Future<void> removeFromCart(String id);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient _dioClient;

  CartRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final response = await _dioClient.get(ApiConfig.cart);
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CartItemModel> addToCart(AddToCartRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.cartItems,
        data: request.toJson(),
      );
      return CartItemModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CartItemModel> updateCartItem(String id, UpdateCartItemRequest request) async {
    try {
      final response = await _dioClient.put(
        '${ApiConfig.cartItems}/$id',
        data: request.toJson(),
      );
      return CartItemModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> removeFromCart(String id) async {
    try {
      await _dioClient.delete('${ApiConfig.cartItems}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _dioClient.delete(ApiConfig.cart);
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
final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl(ref.read(dioClientProvider));
});
