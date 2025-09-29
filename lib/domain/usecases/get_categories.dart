import 'package:dartz/dartz.dart';
import '../repositories/product_repository.dart';
import '../../core/failure.dart';

class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() {
    return repository.getCategories();
  }
}