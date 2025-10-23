import 'package:ua/feature/product/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    int? limit,
    int? offset,
  });

  Future<ProductModel> getProductById(String id);

  Future<List<ProductModel>> getFeaturedProducts();

  Future<List<String>> getCategories();
}
