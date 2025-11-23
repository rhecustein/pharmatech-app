import 'package:hive/hive.dart';
import '../../../products/data/models/product_model.dart';

part 'order_model.g.dart';

enum OrderStatus {
  pending,
  processing,
  shipping,
  completed,
  cancelled,
}

enum PaymentMethod {
  cod,
  bankTransfer,
  eWallet,
  creditCard,
}

enum ShippingMethod {
  regular,
  express,
  sameDay,
}

@HiveType(typeId: 4)
class OrderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String orderNumber;

  @HiveField(2)
  final OrderStatus status;

  @HiveField(3)
  final List<OrderItemModel> items;

  @HiveField(4)
  final int subtotal;

  @HiveField(5)
  final int shippingCost;

  @HiveField(6)
  final int total;

  @HiveField(7)
  final PaymentMethod paymentMethod;

  @HiveField(8)
  final ShippingMethod shippingMethod;

  @HiveField(9)
  final AddressModel shippingAddress;

  @HiveField(10)
  final String? trackingNumber;

  @HiveField(11)
  final String? courier;

  @HiveField(12)
  final String? notes;

  @HiveField(13)
  final DateTime? estimatedDelivery;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.paymentMethod,
    required this.shippingMethod,
    required this.shippingAddress,
    this.trackingNumber,
    this.courier,
    this.notes,
    this.estimatedDelivery,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: json['subtotal'] as int,
      shippingCost: json['shipping_cost'] as int,
      total: json['total'] as int,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['payment_method'],
      ),
      shippingMethod: ShippingMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['shipping_method'],
      ),
      shippingAddress: AddressModel.fromJson(
        json['shipping_address'] as Map<String, dynamic>,
      ),
      trackingNumber: json['tracking_number'] as String?,
      courier: json['courier'] as String?,
      notes: json['notes'] as String?,
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status.toString().split('.').last,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'total': total,
      'payment_method': paymentMethod.toString().split('.').last,
      'shipping_method': shippingMethod.toString().split('.').last,
      'shipping_address': shippingAddress.toJson(),
      'tracking_number': trackingNumber,
      'courier': courier,
      'notes': notes,
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

@HiveType(typeId: 5)
class OrderItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final ProductModel product;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final int price;

  @HiveField(5)
  final int subtotal;

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      price: json['price'] as int,
      subtotal: json['subtotal'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
    };
  }
}

@HiveType(typeId: 6)
class AddressModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String? province;

  @HiveField(6)
  final String? city;

  @HiveField(7)
  final String? district;

  @HiveField(8)
  final String? postalCode;

  @HiveField(9)
  final bool isDefault;

  @HiveField(10)
  final double? latitude;

  @HiveField(11)
  final double? longitude;

  AddressModel({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.address,
    this.province,
    this.city,
    this.district,
    this.postalCode,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      label: json['label'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      province: json['province'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      postalCode: json['postal_code'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'name': name,
      'phone': phone,
      'address': address,
      'province': province,
      'city': city,
      'district': district,
      'postal_code': postalCode,
      'is_default': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get fullAddress {
    final parts = [
      address,
      if (district != null) district,
      if (city != null) city,
      if (province != null) province,
      if (postalCode != null) postalCode,
    ];
    return parts.join(', ');
  }
}

class CreateOrderRequest {
  final List<String> cartItemIds;
  final String addressId;
  final PaymentMethod paymentMethod;
  final ShippingMethod shippingMethod;
  final String? notes;

  CreateOrderRequest({
    required this.cartItemIds,
    required this.addressId,
    required this.paymentMethod,
    required this.shippingMethod,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'cart_item_ids': cartItemIds,
      'address_id': addressId,
      'payment_method': paymentMethod.toString().split('.').last,
      'shipping_method': shippingMethod.toString().split('.').last,
      'notes': notes,
    };
  }
}

@HiveType(typeId: 7)
class TrackingEventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isCompleted;

  TrackingEventModel({
    required this.id,
    required this.title,
    this.description,
    required this.timestamp,
    required this.isCompleted,
  });

  factory TrackingEventModel.fromJson(Map<String, dynamic> json) {
    return TrackingEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isCompleted: json['is_completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'is_completed': isCompleted,
    };
  }
}
