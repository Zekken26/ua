import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  const CartItem({
    required this.productId,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });

  @override
  List<Object?> get props => [productId, quantity, selectedSize, selectedColor];
}