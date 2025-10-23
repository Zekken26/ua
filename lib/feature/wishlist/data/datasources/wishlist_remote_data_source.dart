import 'package:ua/feature/wishlist/data/models/wishlist_item_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<WishlistItemModel>> getWishlist();
  Future<void> addToWishlist(String productId);
  Future<void> removeFromWishlist(String productId);
  Future<bool> isInWishlist(String productId);
}
