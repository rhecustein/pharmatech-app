import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/models/cart_model.dart';

// Cart State
class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  // Computed properties
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int get selectedItemCount =>
      items.where((item) => item.isSelected).fold(0, (sum, item) => sum + item.quantity);

  int get subtotal => items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.subtotal);

  List<CartItemModel> get selectedItems =>
      items.where((item) => item.isSelected).toList();
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  final CartRemoteDataSource _dataSource;

  CartNotifier(this._dataSource) : super(CartState()) {
    getCartItems();
  }

  // Get cart items
  Future<void> getCartItems() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _dataSource.getCartItems();
      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Add to cart
  Future<void> addToCart(String productId, int quantity) async {
    try {
      final request = AddToCartRequest(
        productId: productId,
        quantity: quantity,
      );
      final newItem = await _dataSource.addToCart(request);

      // Check if item already exists
      final existingIndex = state.items.indexWhere(
        (item) => item.productId == productId,
      );

      if (existingIndex != -1) {
        // Update existing item
        final updatedItems = [...state.items];
        updatedItems[existingIndex] = newItem;
        state = state.copyWith(items: updatedItems);
      } else {
        // Add new item
        state = state.copyWith(items: [...state.items, newItem]);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Update cart item quantity
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    try {
      final request = UpdateCartItemRequest(quantity: quantity);
      final updatedItem = await _dataSource.updateCartItem(itemId, request);

      final updatedItems = state.items.map((item) {
        if (item.id == itemId) {
          return updatedItem;
        }
        return item;
      }).toList();

      state = state.copyWith(items: updatedItems);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      await _dataSource.removeFromCart(itemId);

      final updatedItems = state.items.where((item) => item.id != itemId).toList();
      state = state.copyWith(items: updatedItems);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Toggle item selection
  void toggleSelection(String itemId) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isSelected: !item.isSelected);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Select all items
  void selectAll(bool selected) {
    final updatedItems = state.items.map((item) {
      return item.copyWith(isSelected: selected);
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _dataSource.clearCart();
      state = state.copyWith(items: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Increment quantity
  Future<void> incrementQuantity(String itemId) async {
    final item = state.items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity + 1);
  }

  // Decrement quantity
  Future<void> decrementQuantity(String itemId) async {
    final item = state.items.firstWhere((item) => item.id == itemId);
    await updateQuantity(itemId, item.quantity - 1);
  }
}

// Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.read(cartRemoteDataSourceProvider));
});

// Convenience providers
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartSubtotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).subtotal;
});
