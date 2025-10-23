import 'package:ua/feature/checkout/domain/entities/cart_item.dart';
import 'package:ua/feature/checkout/domain/entities/order.dart' as domain;
import 'package:ua/feature/checkout/data/models/order_model.dart';

/// Remote data source for Checkout operations.
///
/// Signatures mirror [OrderRepository] but return [OrderModel]s
/// and omit Either<> wrappers.
abstract class CheckoutRemoteDataSource {
  Future<OrderModel> placeOrder({
    required List<CartItem> items,
    required String address,
    required domain.PaymentMethod paymentMethod,
  });

  Future<List<OrderModel>> getOrderHistory();

  Future<OrderModel> getOrderById(String orderId);
}
