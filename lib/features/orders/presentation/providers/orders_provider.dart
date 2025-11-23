import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/orders_remote_datasource.dart';
import '../../data/models/order_model.dart';

// Orders State
class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;

  OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }
}

// Orders Notifier
class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrdersRemoteDataSource _dataSource;

  OrdersNotifier(this._dataSource) : super(OrdersState()) {
    getOrders();
  }

  // Get orders
  Future<void> getOrders({OrderStatus? status}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await _dataSource.getOrders(status: status);
      state = state.copyWith(
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Create order
  Future<OrderModel> createOrder(CreateOrderRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _dataSource.createOrder(request);
      state = state.copyWith(
        orders: [order, ...state.orders],
        isLoading: false,
      );
      return order;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      await _dataSource.cancelOrder(orderId);

      // Update local state
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return OrderModel(
            id: order.id,
            orderNumber: order.orderNumber,
            status: OrderStatus.cancelled,
            items: order.items,
            subtotal: order.subtotal,
            shippingCost: order.shippingCost,
            total: order.total,
            paymentMethod: order.paymentMethod,
            shippingMethod: order.shippingMethod,
            shippingAddress: order.shippingAddress,
            trackingNumber: order.trackingNumber,
            courier: order.courier,
            notes: order.notes,
            estimatedDelivery: order.estimatedDelivery,
            createdAt: order.createdAt,
            updatedAt: DateTime.now(),
          );
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

// Addresses State
class AddressesState {
  final List<AddressModel> addresses;
  final bool isLoading;
  final String? error;

  AddressesState({
    this.addresses = const [],
    this.isLoading = false,
    this.error,
  });

  AddressesState copyWith({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressesState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  AddressModel? get defaultAddress {
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (e) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }
}

// Addresses Notifier
class AddressesNotifier extends StateNotifier<AddressesState> {
  final OrdersRemoteDataSource _dataSource;

  AddressesNotifier(this._dataSource) : super(AddressesState()) {
    getAddresses();
  }

  Future<void> getAddresses() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final addresses = await _dataSource.getAddresses();
      state = state.copyWith(
        addresses: addresses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createAddress(Map<String, dynamic> data) async {
    try {
      final address = await _dataSource.createAddress(data);
      state = state.copyWith(
        addresses: [...state.addresses, address],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> updateAddress(String id, Map<String, dynamic> data) async {
    try {
      final address = await _dataSource.updateAddress(id, data);
      final updatedAddresses = state.addresses.map((addr) {
        if (addr.id == id) return address;
        return addr;
      }).toList();

      state = state.copyWith(addresses: updatedAddresses);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _dataSource.deleteAddress(id);
      final updatedAddresses = state.addresses.where((addr) => addr.id != id).toList();
      state = state.copyWith(addresses: updatedAddresses);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      await _dataSource.setDefaultAddress(id);
      final updatedAddresses = state.addresses.map((addr) {
        return AddressModel(
          id: addr.id,
          label: addr.label,
          name: addr.name,
          phone: addr.phone,
          address: addr.address,
          province: addr.province,
          city: addr.city,
          district: addr.district,
          postalCode: addr.postalCode,
          isDefault: addr.id == id,
          latitude: addr.latitude,
          longitude: addr.longitude,
        );
      }).toList();

      state = state.copyWith(addresses: updatedAddresses);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

// Providers
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(ref.read(ordersRemoteDataSourceProvider));
});

final addressesProvider = StateNotifierProvider<AddressesNotifier, AddressesState>((ref) {
  return AddressesNotifier(ref.read(ordersRemoteDataSourceProvider));
});

// Order Detail Provider
final orderDetailProvider = FutureProvider.family<OrderModel, String>((ref, id) async {
  final dataSource = ref.read(ordersRemoteDataSourceProvider);
  return dataSource.getOrderById(id);
});

// Order Tracking Provider
final orderTrackingProvider =
    FutureProvider.family<List<TrackingEventModel>, String>((ref, orderId) async {
  final dataSource = ref.read(ordersRemoteDataSourceProvider);
  return dataSource.getOrderTracking(orderId);
});

// Default Address Provider
final defaultAddressProvider = Provider<AddressModel?>((ref) {
  return ref.watch(addressesProvider).defaultAddress;
});
