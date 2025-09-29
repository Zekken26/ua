import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../core/failure.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call({
    String? category,
    String? searchQuery,
    int? limit,
    int? offset,
  }) {
    return repository.getProducts(
      category: category,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
}