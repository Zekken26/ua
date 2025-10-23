import 'package:dartz/dartz.dart' as d;
import 'package:ua/core/failure.dart';
import 'package:ua/feature/checkout/domain/entities/order.dart' as domain;
import 'package:ua/feature/checkout/domain/entities/cart_item.dart' as domain;
import 'package:ua/feature/checkout/domain/repositories/order_repository.dart';
import 'package:ua/feature/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class OrderRepositoryImpl implements OrderRepository {
  final CheckoutRemoteDataSource remote;

  OrderRepositoryImpl(this.remote);

  @override
  Future<d.Either<Failure, domain.Order>> placeOrder({
    required List<domain.CartItem> items,
    required String address,
    required domain.PaymentMethod paymentMethod,
  }) async {
    try {
      final model = await remote.placeOrder(
        items: items,
        address: address,
        paymentMethod: paymentMethod,
      );
      return d.Right(model);
    } on fb.FirebaseAuthException catch (e) {
      return d.Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, List<domain.Order>>> getOrderHistory() async {
    try {
      final models = await remote.getOrderHistory();
      return d.Right(models);
    } on fb.FirebaseAuthException catch (e) {
      return d.Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, domain.Order>> getOrderById(String orderId) async {
    try {
      final model = await remote.getOrderById(orderId);
      return d.Right(model);
    } on fb.FirebaseAuthException catch (e) {
      return d.Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }
}
