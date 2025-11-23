import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final int? originalPrice;

  @HiveField(5)
  final int stock;

  @HiveField(6)
  final String categoryId;

  @HiveField(7)
  final String categoryName;

  @HiveField(8)
  final List<String> images;

  @HiveField(9)
  final double rating;

  @HiveField(10)
  final int reviewCount;

  @HiveField(11)
  final int soldCount;

  @HiveField(12)
  final String? composition;

  @HiveField(13)
  final String? indication;

  @HiveField(14)
  final String? dosage;

  @HiveField(15)
  final String? sideEffects;

  @HiveField(16)
  final String? warnings;

  @HiveField(17)
  final bool isPrescriptionRequired;

  @HiveField(18)
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    this.composition,
    this.indication,
    this.dosage,
    this.sideEffects,
    this.warnings,
    required this.isPrescriptionRequired,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      originalPrice: json['original_price'] as int?,
      stock: json['stock'] as int,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      soldCount: json['sold_count'] as int,
      composition: json['composition'] as String?,
      indication: json['indication'] as String?,
      dosage: json['dosage'] as String?,
      sideEffects: json['side_effects'] as String?,
      warnings: json['warnings'] as String?,
      isPrescriptionRequired: json['is_prescription_required'] as bool,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'original_price': originalPrice,
      'stock': stock,
      'category_id': categoryId,
      'category_name': categoryName,
      'images': images,
      'rating': rating,
      'review_count': reviewCount,
      'sold_count': soldCount,
      'composition': composition,
      'indication': indication,
      'dosage': dosage,
      'side_effects': sideEffects,
      'warnings': warnings,
      'is_prescription_required': isPrescriptionRequired,
      'is_favorite': isFavorite,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    int? originalPrice,
    int? stock,
    String? categoryId,
    String? categoryName,
    List<String>? images,
    double? rating,
    int? reviewCount,
    int? soldCount,
    String? composition,
    String? indication,
    String? dosage,
    String? sideEffects,
    String? warnings,
    bool? isPrescriptionRequired,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      soldCount: soldCount ?? this.soldCount,
      composition: composition ?? this.composition,
      indication: indication ?? this.indication,
      dosage: dosage ?? this.dosage,
      sideEffects: sideEffects ?? this.sideEffects,
      warnings: warnings ?? this.warnings,
      isPrescriptionRequired: isPrescriptionRequired ?? this.isPrescriptionRequired,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  int get discount {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice! * 100).round();
    }
    return 0;
  }

  bool get isOnSale => discount > 0;

  bool get isInStock => stock > 0;
}

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? icon;

  @HiveField(3)
  final String? image;

  @HiveField(4)
  final int productCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.image,
    required this.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      productCount: json['product_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'image': image,
      'product_count': productCount,
    };
  }
}
