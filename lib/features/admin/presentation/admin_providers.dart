import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_repository.dart';
import '../domain/school_entities.dart';
import '../domain/user_entities.dart';

// Repository Provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

// --- Stream Providers ---

final classesProvider = StreamProvider.autoDispose<List<Classroom>>((ref) {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getClassrooms();
});

// For now, fetch ALL sections (Admin view). Later can filter by Class.
final sectionsProvider = StreamProvider.autoDispose<List<Section>>((ref) {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getSections();
});

final studentsProvider = StreamProvider.autoDispose<List<Student>>((ref) {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getStudents();
});

final teachersProvider = StreamProvider.autoDispose<List<UserProfile>>((ref) {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getTeachers();
});
