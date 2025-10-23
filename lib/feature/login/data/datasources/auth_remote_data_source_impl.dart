import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:ua/feature/login/domain/entities/user.dart' as domain;
import 'package:ua/feature/login/data/models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _auth;
  final fs.FirebaseFirestore _db;

  AuthRemoteDataSourceImpl({
    fb.FirebaseAuth? firebaseAuth,
    fs.FirebaseFirestore? firestore,
  }) : _auth = firebaseAuth ?? fb.FirebaseAuth.instance,
       _db = firestore ?? fs.FirebaseFirestore.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found after sign-in.',
      );
    }
    final role = await _resolveUserRole(user);
    return UserModel.fromFirebase(user, role: role);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'user-not-created',
        message: 'User not created after registration.',
      );
    }
    if (name.isNotEmpty) {
      await user.updateDisplayName(name);
      await user.reload();
    }
    // Ensure a user document exists with a default role
    await _db.collection('users').doc(user.uid).set({
      'id': user.uid,
      'name': name.isNotEmpty ? name : (user.displayName ?? ''),
      'email': email,
      'role': 'customer',
      'createdAt': fs.FieldValue.serverTimestamp(),
    }, fs.SetOptions(merge: true));

    final refreshed = _auth.currentUser ?? user;
    final role = await _resolveUserRole(refreshed);
    return UserModel.fromFirebase(refreshed, role: role);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final role = await _resolveUserRole(user);
    return UserModel.fromFirebase(user, role: role);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<UserModel> updateProfile(UserModel userModel) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw fb.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No current user to update.',
      );
    }
    // Update display name when provided
    if (userModel.name != user.displayName && userModel.name.isNotEmpty) {
      await user.updateDisplayName(userModel.name);
    }
    // Updating email requires recent login; skip unless matching
    if (userModel.email != user.email) {
      // Optionally implement email update flow with re-authentication
      // For now we skip changing email to avoid failures without credentials.
    }
    await user.reload();
    final refreshed = _auth.currentUser ?? user;
    final role = await _resolveUserRole(refreshed);
    return UserModel.fromFirebase(refreshed, role: role);
  }

  Future<domain.UserRole> _resolveUserRole(fb.User user) async {
    try {
      // Prefer custom claims
      final token = await user.getIdTokenResult(true);
      final isAdmin = (token.claims?['admin'] == true);
      if (isAdmin) return domain.UserRole.admin;
    } catch (_) {
      // ignore and fallback to Firestore
    }

    try {
      // Fallback to Firestore user profile document
      final doc = await _db.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        final role = (data['role'] as String?)?.toLowerCase();
        if (role == 'admin') return domain.UserRole.admin;
      }
    } catch (_) {
      // ignore and default to customer
    }
    return domain.UserRole.customer;
  }
}
