import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:ua/feature/wishlist/domain/entities/wishlist_item.dart'
    as domain;

class WishlistItemModel extends domain.WishlistItem {
  const WishlistItemModel({required super.productId, required super.addedAt});

  factory WishlistItemModel.fromFirestore(
    fs.DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return WishlistItemModel(
      productId: data['productId'] as String? ?? doc.id,
      addedAt: _parseTimestamp(data['addedAt']) ?? DateTime.now(),
    );
  }

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      productId: json['productId'] as String,
      addedAt:
          DateTime.tryParse(json['addedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'addedAt': fs.FieldValue.serverTimestamp(),
  };

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is fs.Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
