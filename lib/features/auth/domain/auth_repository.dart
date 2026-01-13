import 'user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  
  // Phone Auth
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(Exception e) onVerificationFailed,
    required Function(String verificationId) onCodeAutoRetrievalTimeout,
  });
  
  Future<void> signInWithSmsCode({
    required String verificationId, 
    required String smsCode
  });

  // Email Auth (Admin/Teacher)
  Future<void> signInWithEmailAndPassword(String email, String password);
  
  Future<void> signOut();
  
  // Legacy/Mock (Remove later if strictly breaking, or keep for dev)
  // Future<UserEntity> login(UserRole role); 
}
