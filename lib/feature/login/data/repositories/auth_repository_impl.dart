import 'package:dartz/dartz.dart';
import 'package:ua/core/failure.dart';
import 'package:ua/feature/login/domain/entities/user.dart' as domain;
import 'package:ua/feature/login/domain/repositories/auth_repository.dart';
import 'package:ua/feature/login/data/models/user_model.dart';
import 'package:ua/feature/login/data/datasources/auth_remote_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, domain.User>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await remote.login(email, password);
      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, domain.User>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await remote.register(name, email, password);
      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, domain.User?>> getCurrentUser() async {
    try {
      final user = await remote.getCurrentUser();
      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Failed to get current user'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remote.logout();
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Logout failed'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, domain.User>> updateProfile(domain.User user) async {
    try {
      // Ensure we send a model to the data source
      final updated = await remote.updateProfile(_ensureModel(user));
      return Right(updated);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? 'Update profile failed'));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // If a domain.User is provided, convert to UserModel where needed.
  // Keeps boundary clean: data layer operates on models.
  UserModel _ensureModel(domain.User user) {
    if (user is UserModel) return user;
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      role: user.role,
      createdAt: user.createdAt,
    );
  }
}
