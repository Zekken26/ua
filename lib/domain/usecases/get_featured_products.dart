import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../core/failure.dart';

class GetFeaturedProductsUseCase {
  final ProductRepository repository;

  GetFeaturedProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getFeaturedProducts();
  }
}