import 'package:dartz/dartz.dart' as d;
import '../entities/order.dart';
import '../repositories/order_repository.dart';
import 'package:ua/core/failure.dart';

class GetOrderDetailsUseCase {
  final OrderRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<d.Either<Failure, Order>> call(String orderId) {
    return repository.getOrderById(orderId);
  }
}
