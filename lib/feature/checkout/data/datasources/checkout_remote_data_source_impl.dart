import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:ua/feature/checkout/domain/entities/cart_item.dart' as domain;
import 'package:ua/feature/checkout/domain/entities/order.dart' as domain;
import 'package:ua/feature/checkout/data/models/order_model.dart';
import 'package:ua/feature/checkout/data/models/cart_item_model.dart';
import 'checkout_remote_data_source.dart';

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final fs.FirebaseFirestore _db;
  final fb.FirebaseAuth _auth;

  CheckoutRemoteDataSourceImpl({
    fs.FirebaseFirestore? firestore,
    fb.FirebaseAuth? firebaseAuth,
  }) : _db = firestore ?? fs.FirebaseFirestore.instance,
       _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  @override
  Future<OrderModel> placeOrder({
    required List<domain.CartItem> items,
    required String address,
    required domain.PaymentMethod paymentMethod,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user',
      );
    }

    // Convert items to models for serialization
    final itemModels = items
        .map(
          (e) => e is CartItemModel
              ? e
              : CartItemModel(
                  productId: e.productId,
                  quantity: e.quantity,
                  selectedSize: e.selectedSize,
                  selectedColor: e.selectedColor,
                ),
        )
        .toList();

    final total = await _calculateTotal(itemModels);

    final data = OrderModel(
      id: '', // placeholder; Firestore will assign
      userId: user.uid,
      items: itemModels,
      total: total,
      status: domain.OrderStatus.pending,
      createdAt: DateTime.now(),
      address: address,
      paymentMethod: paymentMethod,
      trackingNumber: null,
    ).toJson();

    final ref = await _db.collection('orders').add(data);
    final created = await ref.get();
    return OrderModel.fromFirestore(created);
  }

  @override
  Future<List<OrderModel>> getOrderHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user',
      );
    }
    final snap = await _db
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => OrderModel.fromFirestore(d)).toList();
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    final doc = await _db.collection('orders').doc(orderId).get();
    if (!doc.exists) {
      throw fs.FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Order not found',
      );
    }
    return OrderModel.fromFirestore(doc);
  }

  Future<double> _calculateTotal(List<CartItemModel> items) async {
    double total = 0.0;
    for (final item in items) {
      try {
        final prod = await _db.collection('products').doc(item.productId).get();
        final price = (prod.data()?['price'] as num?)?.toDouble() ?? 0.0;
        total += price * item.quantity;
      } catch (_) {
        // ignore and treat price as 0.0 to avoid blocking order creation; repository will still receive result
      }
    }
    return total;
  }
}
