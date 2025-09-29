import 'package:dartz/dartz.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';
import '../../core/failure.dart';

class GetWishlistUseCase {
  final WishlistRepository repository;

  GetWishlistUseCase(this.repository);

  Future<Either<Failure, List<WishlistItem>>> call() {
    return repository.getWishlist();
  }
}