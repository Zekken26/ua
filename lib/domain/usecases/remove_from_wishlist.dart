import 'package:dartz/dartz.dart';
import '../repositories/wishlist_repository.dart';
import '../../core/failure.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) {
    return repository.removeFromWishlist(productId);
  }
}