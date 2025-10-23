import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:ua/feature/wishlist/data/models/wishlist_item_model.dart';
import 'wishlist_remote_data_source.dart';

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final fs.FirebaseFirestore _db;
  final fb.FirebaseAuth _auth;

  WishlistRemoteDataSourceImpl({
    fs.FirebaseFirestore? firestore,
    fb.FirebaseAuth? firebaseAuth,
  }) : _db = firestore ?? fs.FirebaseFirestore.instance,
       _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user',
      );
    }
    return user.uid;
  }

  fs.CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('users').doc(_uid).collection('wishlist');

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    final snap = await _collection.orderBy('addedAt', descending: true).get();
    return snap.docs.map((d) => WishlistItemModel.fromFirestore(d)).toList();
  }

  @override
  Future<void> addToWishlist(String productId) async {
    final docRef = _collection.doc(productId);
    await docRef.set({
      'productId': productId,
      'addedAt': fs.FieldValue.serverTimestamp(),
    }, fs.SetOptions(merge: true));
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    await _collection.doc(productId).delete();
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    final doc = await _collection.doc(productId).get();
    return doc.exists;
  }
}
