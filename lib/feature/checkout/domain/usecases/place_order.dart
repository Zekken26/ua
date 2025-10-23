import 'package:dartz/dartz.dart' as d;
import '../entities/order.dart';
import '../entities/cart_item.dart';
import '../repositories/order_repository.dart';
import 'package:ua/core/failure.dart';

class PlaceOrderUseCase {
  final OrderRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<d.Either<Failure, Order>> call({
    required List<CartItem> items,
    required String address,
    required PaymentMethod paymentMethod,
  }) {
    return repository.placeOrder(
      items: items,
      address: address,
      paymentMethod: paymentMethod,
    );
  }
}
