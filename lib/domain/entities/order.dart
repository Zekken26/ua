import 'package:equatable/equatable.dart';
import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cashOnDelivery,
  gcash,
  paypal,
}

class Order extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String? address;
  final PaymentMethod paymentMethod;
  final String? trackingNumber;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.address,
    required this.paymentMethod,
    this.trackingNumber,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        total,
        status,
        createdAt,
        address,
        paymentMethod,
        trackingNumber,
      ];
}