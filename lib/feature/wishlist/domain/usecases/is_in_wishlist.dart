import 'package:dartz/dartz.dart';
import '../repositories/wishlist_repository.dart';
import 'package:ua/core/failure.dart';

class IsInWishlistUseCase {
  final WishlistRepository repository;

  IsInWishlistUseCase(this.repository);

  Future<Either<Failure, bool>> call(String productId) {
    return repository.isInWishlist(productId);
  }
}
