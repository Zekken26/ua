import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:ua/feature/product/data/models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final fs.FirebaseFirestore _db;

  ProductRemoteDataSourceImpl({fs.FirebaseFirestore? firestore})
    : _db = firestore ?? fs.FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    var query = _db
        .collection('products')
        .orderBy('createdAt', descending: true);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    // Fetch more to accommodate offset, then slice in memory as a simple approach
    final fetchLimit = ((limit ?? 20) + (offset ?? 0));
    final snap = await query.limit(fetchLimit).get();
    var models = snap.docs.map((d) => ProductModel.fromFirestore(d)).toList();

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      models = models
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q),
          )
          .toList();
    }

    if (offset != null && offset > 0) {
      models = models.skip(offset).toList();
    }
    if (limit != null) {
      models = models.take(limit).toList();
    }
    return models;
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) {
      throw fs.FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Product not found',
      );
    }
    return ProductModel.fromFirestore(doc);
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final snap = await _db
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => ProductModel.fromFirestore(d)).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    // Prefer a dedicated categories collection; fallback to distinct categories from products
    try {
      final catSnap = await _db.collection('categories').get();
      final names = <String>[];
      for (final d in catSnap.docs) {
        final data = d.data();
        final name = data['name'] as String?;
        if (name != null && name.isNotEmpty) names.add(name);
      }
      if (names.isNotEmpty) return names;
    } catch (_) {
      // ignore and fallback
    }

    final prodSnap = await _db.collection('products').get();
    final set = <String>{};
    for (final d in prodSnap.docs) {
      final cat = d.data()['category'] as String?;
      if (cat != null && cat.isNotEmpty) set.add(cat);
    }
    return set.toList()..sort();
  }
}
