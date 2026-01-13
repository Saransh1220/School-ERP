enum UserRole { admin, teacher, parent }

class UserEntity {
  final String uid;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
  });
}
