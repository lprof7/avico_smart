import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Auth Repository - Abstraction over Auth Service
class AuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
    : _authService = authService;

  /// Check if user is logged in
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Get current user
  User? get currentUser => _authService.currentUser;

  /// Auth state stream
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Login with email and password
  Future<User?> login({required String email, required String password}) async {
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on AuthException {
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _authService.signOut();
  }
}
