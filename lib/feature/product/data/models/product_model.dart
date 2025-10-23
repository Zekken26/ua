import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:ua/feature/product/domain/entities/product.dart' as domain;

class ProductModel extends domain.Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.images,
    required super.category,
    required super.sizes,
    required super.colors,
    required super.stock,
    required super.isFeatured,
    required super.createdAt,
  });

  factory ProductModel.fromFirestore(
    fs.DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      images: (data['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      category: data['category'] as String? ?? '',
      sizes: (data['sizes'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      colors: (data['colors'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      stock: (data['stock'] as num?)?.toInt() ?? 0,
      isFeatured: (data['isFeatured'] as bool?) ?? false,
      createdAt: _parseTimestamp(data['createdAt']) ?? DateTime.now(),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      category: json['category'] as String? ?? '',
      sizes: (json['sizes'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      colors: (json['colors'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isFeatured: (json['isFeatured'] as bool?) ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'category': category,
      'sizes': sizes,
      'colors': colors,
      'stock': stock,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is fs.Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
