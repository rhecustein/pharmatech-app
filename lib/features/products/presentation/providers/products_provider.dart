import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/products_remote_datasource.dart';
import '../../data/models/product_model.dart';

// Products State
class ProductsState {
  final List<ProductModel> products;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 1,
  });

  ProductsState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Products Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRemoteDataSource _dataSource;

  ProductsNotifier(this._dataSource) : super(ProductsState());

  // Get products with filters
  Future<void> getProducts({
    String? categoryId,
    String? search,
    String? sortBy,
    int? minPrice,
    int? maxPrice,
    double? minRating,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = ProductsState();
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newProducts = await _dataSource.getProducts(
        categoryId: categoryId,
        search: search,
        sortBy: sortBy,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        page: state.currentPage,
      );

      state = state.copyWith(
        products: refresh ? newProducts : [...state.products, ...newProducts],
        isLoading: false,
        hasMore: newProducts.length >= 20,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Load more products
  Future<void> loadMore({
    String? categoryId,
    String? search,
    String? sortBy,
    int? minPrice,
    int? maxPrice,
    double? minRating,
  }) async {
    if (!state.hasMore || state.isLoading) return;

    await getProducts(
      categoryId: categoryId,
      search: search,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
    );
  }

  // Toggle favorite
  Future<void> toggleFavorite(String productId) async {
    try {
      await _dataSource.toggleFavorite(productId);

      // Update local state
      final updatedProducts = state.products.map((product) {
        if (product.id == productId) {
          return product.copyWith(isFavorite: !product.isFavorite);
        }
        return product;
      }).toList();

      state = state.copyWith(products: updatedProducts);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Categories State
class CategoriesState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;

  CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Categories Notifier
class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final ProductsRemoteDataSource _dataSource;

  CategoriesNotifier(this._dataSource) : super(CategoriesState()) {
    getCategories();
  }

  Future<void> getCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categories = await _dataSource.getCategories();
      state = state.copyWith(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Providers
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref.read(productsRemoteDataSourceProvider));
});

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  return CategoriesNotifier(ref.read(productsRemoteDataSourceProvider));
});

// Product Detail Provider
final productDetailProvider = FutureProvider.family<ProductModel, String>((ref, id) async {
  final dataSource = ref.read(productsRemoteDataSourceProvider);
  return dataSource.getProductById(id);
});

// Search Provider
final searchProductsProvider = FutureProvider.family<List<ProductModel>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final dataSource = ref.read(productsRemoteDataSourceProvider);
  return dataSource.searchProducts(query);
});

// Favorites Provider
final favoritesProvider = FutureProvider<List<ProductModel>>((ref) async {
  final dataSource = ref.read(productsRemoteDataSourceProvider);
  return dataSource.getFavorites();
});
