import 'package:ua/feature/checkout/domain/entities/cart_item.dart' as domain;

class CartItemModel extends domain.CartItem {
  const CartItemModel({
    required super.productId,
    required super.quantity,
    super.selectedSize,
    super.selectedColor,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      selectedSize: json['selectedSize'] as String?,
      selectedColor: json['selectedColor'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'selectedSize': selectedSize,
    'selectedColor': selectedColor,
  };
}
