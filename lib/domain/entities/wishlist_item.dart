import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String productId;
  final DateTime addedAt;

  const WishlistItem({
    required this.productId,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [productId, addedAt];
}