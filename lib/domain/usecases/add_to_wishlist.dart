import 'package:dartz/dartz.dart';
import '../repositories/wishlist_repository.dart';
import '../../core/failure.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) {
    return repository.addToWishlist(productId);
  }
}