import 'package:hive/hive.dart';
import '../../../products/data/models/product_model.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 3)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final ProductModel product;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final bool isSelected;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    this.isSelected = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      isSelected: json['is_selected'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product.toJson(),
      'quantity': quantity,
      'is_selected': isSelected,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CartItemModel copyWith({
    String? id,
    String? productId,
    ProductModel? product,
    int? quantity,
    bool? isSelected,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get subtotal => product.price * quantity;
}

class AddToCartRequest {
  final String productId;
  final int quantity;

  AddToCartRequest({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
    };
  }
}

class UpdateCartItemRequest {
  final int quantity;

  UpdateCartItemRequest({
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
    };
  }
}
