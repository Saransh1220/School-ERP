import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

// Provider for the repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

// Stream of auth state changes (for consistent listening across the app)
final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Controller for performing auth actions
// Controller for performing auth actions
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is null (data)
    return null;
  }

  Future<void> login(UserRole role) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).login(role));
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).logout());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});
