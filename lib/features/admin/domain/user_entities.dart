import 'package:equatable/equatable.dart';

enum UserRole { admin, teacher, parent }

// Generic User Profile (fetched from 'users' collection)
class UserProfile extends Equatable {
  final String uid;
  final String email;
  final UserRole role; // Enum handling
  final String? fullName;
  final String? phone;
  final List<String> linkedStudentIds; // For Parents
  final List<String> assignedSectionIds; // For Teachers

  const UserProfile({
    required this.uid,
    required this.email,
    required this.role,
    this.fullName,
    this.phone,
    this.linkedStudentIds = const [],
    this.assignedSectionIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role.name,
      'fullName': fullName,
      'phone': phone,
      'linkedStudentIds': linkedStudentIds,
      'assignedSectionIds': assignedSectionIds,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    return UserProfile(
      uid: uid,
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere((e) => e.name == map['role'], orElse: () => UserRole.parent),
      fullName: map['fullName'],
      phone: map['phone'],
      linkedStudentIds: List<String>.from(map['linkedStudentIds'] ?? []),
      assignedSectionIds: List<String>.from(map['assignedSectionIds'] ?? []),
    );
  }

  @override
  List<Object?> get props => [uid, email, role, fullName, phone, linkedStudentIds, assignedSectionIds];
}
