import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/config/api_config.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';

// Auth State
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthNotifier(this._authRemoteDataSource) : super(AuthState()) {
    _checkAuthStatus();
  }

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    try {
      final box = await Hive.openBox('auth');
      final userJson = box.get(ApiConfig.userKey);
      final token = box.get(ApiConfig.accessTokenKey);

      if (userJson != null && token != null) {
        final user = UserModel.fromJson(Map<String, dynamic>.from(userJson));
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
        );
      }
    } catch (e) {
      state = state.copyWith(isAuthenticated: false);
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authRemoteDataSource.login(request);

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      final response = await _authRemoteDataSource.register(request);

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authRemoteDataSource.logout();
      state = AuthState();
    } catch (e) {
      // Clear local state even if API call fails
      state = AuthState();
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRemoteDataSource.forgotPassword(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // Get Profile
  Future<void> getProfile() async {
    try {
      final user = await _authRemoteDataSource.getProfile();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Update Profile
  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _authRemoteDataSource.updateProfile(data);
      state = state.copyWith(
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRemoteDataSourceProvider));
});

// Convenience providers
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
