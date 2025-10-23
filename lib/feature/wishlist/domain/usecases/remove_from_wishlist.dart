import 'package:dartz/dartz.dart';
import '../repositories/wishlist_repository.dart';
import 'package:ua/core/failure.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) {
    return repository.removeFromWishlist(productId);
  }
}
