import 'package:dartz/dartz.dart' as d;
import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../core/failure.dart';

class GetOrderHistoryUseCase {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Future<d.Either<Failure, List<Order>>> call() {
    return repository.getOrderHistory();
  }
}