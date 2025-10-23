import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:ua/feature/checkout/domain/entities/order.dart' as domain;
import 'package:ua/feature/checkout/data/models/cart_item_model.dart';

class OrderModel extends domain.Order {
  const OrderModel({
    required super.id,
    required super.userId,
    required List<CartItemModel> items,
    required super.total,
    required super.status,
    required super.createdAt,
    super.address,
    required super.paymentMethod,
    super.trackingNumber,
  }) : super(items: items);

  List<CartItemModel> get itemsAsModel => items.cast<CartItemModel>();

  factory OrderModel.fromFirestore(
    fs.DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final items = (data['items'] as List<dynamic>? ?? const [])
        .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    final createdAt = _parseTimestamp(data['createdAt']);
    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      items: items,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(data['status'] as String?),
      createdAt: createdAt ?? DateTime.now(),
      address: data['address'] as String?,
      paymentMethod: _paymentFromString(data['paymentMethod'] as String?),
      trackingNumber: data['trackingNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': itemsAsModel.map((e) => e.toJson()).toList(),
      'total': total,
      'status': status.name,
      'createdAt': fs.FieldValue.serverTimestamp(),
      'address': address,
      'paymentMethod': paymentMethod.name,
      'trackingNumber': trackingNumber,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is fs.Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static domain.OrderStatus _statusFromString(String? value) {
    switch (value) {
      case 'confirmed':
        return domain.OrderStatus.confirmed;
      case 'shipped':
        return domain.OrderStatus.shipped;
      case 'delivered':
        return domain.OrderStatus.delivered;
      case 'cancelled':
        return domain.OrderStatus.cancelled;
      case 'pending':
      default:
        return domain.OrderStatus.pending;
    }
  }

  static domain.PaymentMethod _paymentFromString(String? value) {
    switch (value) {
      case 'gcash':
        return domain.PaymentMethod.gcash;
      case 'paypal':
        return domain.PaymentMethod.paypal;
      case 'cashOnDelivery':
      default:
        return domain.PaymentMethod.cashOnDelivery;
    }
  }
}
