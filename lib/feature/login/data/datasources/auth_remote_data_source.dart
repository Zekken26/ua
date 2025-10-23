import 'package:ua/feature/login/data/models/user_model.dart';

/// Remote data source for authentication.
///
/// Notes on roles (admin vs customer):
/// - On every auth event we resolve the role in this order:
///   1) Firebase Custom Claims: expects a boolean `admin` claim set via Admin SDK.
///   2) Firestore fallback: reads `users/{uid}` document with `role: 'admin'|'customer'`.
/// - Registration ensures a `users/{uid}` doc exists with default `role: 'customer'`.
/// - Update profile merges into the same document; role is not changed here.
abstract class AuthRemoteDataSource {
  /// Sign in with email/password and return the resolved [UserModel].
  Future<UserModel> login(String email, String password);

  /// Register a new account, creates/merges a Firestore `users/{uid}` doc
  /// with default `role: 'customer'`, and returns the resolved [UserModel].
  Future<UserModel> register(String name, String email, String password);

  /// Returns the current user if signed in, with resolved role, else null.
  Future<UserModel?> getCurrentUser();

  /// Sign out current user.
  Future<void> logout();

  /// Update profile details. Role changes are not handled here.
  Future<UserModel> updateProfile(UserModel user);
}
