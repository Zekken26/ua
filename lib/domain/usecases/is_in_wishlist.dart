import 'package:dartz/dartz.dart';
import '../repositories/wishlist_repository.dart';
import '../../core/failure.dart';

class IsInWishlistUseCase {
  final WishlistRepository repository;

  IsInWishlistUseCase(this.repository);

  Future<Either<Failure, bool>> call(String productId) {
    return repository.isInWishlist(productId);
  }
}