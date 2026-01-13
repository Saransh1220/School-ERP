import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firebase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

// Provider for the repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

// Stream of auth state changes (for consistent listening across the app)
final authStateChangesProvider = StreamProvider<UserEntity?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Controller for performing auth actions
class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  // Legacy/Dev Mock Login (Optional, maybe remove?)
  /*
  Future<void> login(UserRole role) async {
    state = const AsyncValue.loading();
    // state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).login(role));
  }
  */

  Future<void> sendOtp({
     required String phoneNumber,
     required Function(String, int?) onCodeSent,
     required Function(Exception) onVerificationFailed,
     required Function(String) onCodeAutoRetrievalTimeout,
  }) async {
    state = const AsyncValue.loading();
    try {
       await ref.read(authRepositoryProvider).verifyPhoneNumber(
         phoneNumber: phoneNumber, 
         onCodeSent: onCodeSent, 
         onVerificationFailed: onVerificationFailed, 
         onCodeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout
       );
       state = const AsyncValue.data(null); // Success (initiation)
    } catch (e, st) {
       state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyOtp({required String verificationId, required String smsCode}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signInWithSmsCode(verificationId: verificationId, smsCode: smsCode));
  }
  
  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signInWithEmailAndPassword(email, password));
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).signOut());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});
