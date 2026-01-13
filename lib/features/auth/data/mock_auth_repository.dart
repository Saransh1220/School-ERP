import 'dart:async';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity?>.broadcast();

  // Keep track of current user locally for now
  UserEntity? _currentUser;

  MockAuthRepository() {
      // Ensure the initial state is emitted to listeners given it's a broadcast stream
      Future.delayed(const Duration(milliseconds: 50), () {
        _controller.add(_currentUser);
      });
  }

  @override
  Stream<UserEntity?> get authStateChanges => _controller.stream;

  @override
  Future<UserEntity> login(UserRole role) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1)); 
    
    UserEntity user;
    switch (role) {
      case UserRole.admin:
        user = const UserEntity(
          uid: 'admin_1', 
          name: 'Principal Skinner', 
          email: 'admin@school.com', 
          role: UserRole.admin,
          profileImage: 'https://ui-avatars.com/api/?name=Principal+Skinner&background=random',
        );
        break;
      case UserRole.teacher:
        user = const UserEntity(
          uid: 'teacher_1', 
          name: 'Ms. Krabappel', 
          email: 'teacher@school.com', 
          role: UserRole.teacher,
           profileImage: 'https://ui-avatars.com/api/?name=Ms+Krabappel&background=random',
        );
        break;
      case UserRole.parent:
        user = const UserEntity(
          uid: 'parent_1', 
          name: 'Homer Simpson', 
          email: 'parent@school.com', 
          role: UserRole.parent,
           profileImage: 'https://ui-avatars.com/api/?name=Homer+Simpson&background=random',
        );
        break;
    }
    
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _controller.add(null);
  }
}
