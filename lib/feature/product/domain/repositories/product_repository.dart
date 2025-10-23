import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import 'package:ua/core/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    String? category,
    String? searchQuery,
    int? limit,
    int? offset,
  });
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, List<Product>>> getFeaturedProducts();
  Future<Either<Failure, List<String>>> getCategories();
}
