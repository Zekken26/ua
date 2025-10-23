import 'package:dartz/dartz.dart' as d;
import '../entities/order.dart';
import '../entities/cart_item.dart';
import 'package:ua/core/failure.dart';

abstract class OrderRepository {
  Future<d.Either<Failure, Order>> placeOrder({
    required List<CartItem> items,
    required String address,
    required PaymentMethod paymentMethod,
  });
  Future<d.Either<Failure, List<Order>>> getOrderHistory();
  Future<d.Either<Failure, Order>> getOrderById(String orderId);
}
