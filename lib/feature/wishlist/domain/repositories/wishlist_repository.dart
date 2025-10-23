import 'package:dartz/dartz.dart';
import '../entities/wishlist_item.dart';
import 'package:ua/core/failure.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlist();
  Future<Either<Failure, void>> addToWishlist(String productId);
  Future<Either<Failure, void>> removeFromWishlist(String productId);
  Future<Either<Failure, bool>> isInWishlist(String productId);
}
