import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? search,
    String? sortBy,
    int? minPrice,
    int? maxPrice,
    double? minRating,
    int page = 1,
    int limit = 20,
  });
  Future<ProductModel> getProductById(String id);
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> toggleFavorite(String productId);
  Future<List<ProductModel>> getFavorites();
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final DioClient _dioClient;

  ProductsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? search,
    String? sortBy,
    int? minPrice,
    int? maxPrice,
    double? minRating,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (categoryId != null) 'category_id': categoryId,
        if (search != null) 'search': search,
        if (sortBy != null) 'sort_by': sortBy,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minRating != null) 'min_rating': minRating,
      };

      final response = await _dioClient.get(
        ApiConfig.products,
        queryParameters: queryParameters,
      );

      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _dioClient.get('${ApiConfig.products}/$id');
      return ProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.get(ApiConfig.categories);
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _dioClient.get(
        ApiConfig.search,
        queryParameters: {'q': query},
      );
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> toggleFavorite(String productId) async {
    try {
      await _dioClient.post('${ApiConfig.products}/$productId/favorite');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ProductModel>> getFavorites() async {
    try {
      final response = await _dioClient.get('${ApiConfig.products}/favorites');
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
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
final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((ref) {
  return ProductsRemoteDataSourceImpl(ref.read(dioClientProvider));
});
