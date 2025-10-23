import 'package:dartz/dartz.dart' as d;
import 'package:ua/core/failure.dart';
import 'package:ua/feature/wishlist/domain/entities/wishlist_item.dart'
    as domain;
import 'package:ua/feature/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:ua/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fb;

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource remote;

  WishlistRepositoryImpl(this.remote);

  @override
  Future<d.Either<Failure, List<domain.WishlistItem>>> getWishlist() async {
    try {
      final models = await remote.getWishlist();
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
  Future<d.Either<Failure, void>> addToWishlist(String productId) async {
    try {
      await remote.addToWishlist(productId);
      return const d.Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return d.Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, void>> removeFromWishlist(String productId) async {
    try {
      await remote.removeFromWishlist(productId);
      return const d.Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return d.Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }

  @override
  Future<d.Either<Failure, bool>> isInWishlist(String productId) async {
    try {
      final exists = await remote.isInWishlist(productId);
      return d.Right(exists);
    } on fb.FirebaseAuthException catch (e) {
      return d.Left(AuthFailure(e.message ?? 'Authentication failed'));
    } on fs.FirebaseException catch (_) {
      return d.Left(ServerFailure());
    } catch (_) {
      return d.Left(ServerFailure());
    }
  }
}
