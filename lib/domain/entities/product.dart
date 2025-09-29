import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final int stock;
  final bool isFeatured;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.sizes,
    required this.colors,
    required this.stock,
    required this.isFeatured,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        images,
        category,
        sizes,
        colors,
        stock,
        isFeatured,
        createdAt,
      ];
}