import 'package:dartz/dartz.dart' as d;
import 'package:ua/core/failure.dart';
import 'package:ua/feature/product/domain/entities/product.dart' as domain;
import 'package:ua/feature/product/domain/repositories/product_repository.dart';
import 'package:ua/feature/product/data/datasources/product_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<d.Either<Failure, List<domain.Product>>> getProducts({
    String? category,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      final models = await remote.getProducts(
        category: category,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset,
      );
      return d.Right(models);
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, domain.Product>> getProductById(String id) async {
    try {
      final model = await remote.getProductById(id);
      return d.Right(model);
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, List<domain.Product>>> getFeaturedProducts() async {
    try {
      final models = await remote.getFeaturedProducts();
      return d.Right(models);
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, List<String>>> getCategories() async {
    try {
      final list = await remote.getCategories();
      return d.Right(list);
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }
}
