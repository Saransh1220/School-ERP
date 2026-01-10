import 'user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(UserRole role);
  Future<void> logout();
  Stream<UserEntity?> get authStateChanges;
}
