import 'package:equatable/equatable.dart';

// --- Organization ---

class Classroom extends Equatable {
  final String id;
  final String name; // e.g., "Nursery", "LKG"
  final int order; // for sorting

  const Classroom({required this.id, required this.name, required this.order});

  Map<String, dynamic> toMap() => {'name': name, 'order': order};

  factory Classroom.fromMap(String id, Map<String, dynamic> map) {
    return Classroom(
      id: id,
      name: map['name'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, order];
}

class Section extends Equatable {
  final String id;
  final String classId; // Linked to Classroom
  final String name; // e.g., "Nursery A"
  final String? teacherId;

  const Section({
    required this.id,
    required this.classId,
    required this.name,
    this.teacherId,
  });

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'name': name,
      'teacherId': teacherId,
    };
  }

  factory Section.fromMap(String id, Map<String, dynamic> map) {
    return Section(
      id: id,
      classId: map['classId'] ?? '',
      name: map['name'] ?? '',
      teacherId: map['teacherId'],
    );
  }

  @override
  List<Object?> get props => [id, classId, name, teacherId];
}

// --- People ---

class Student extends Equatable {
  final String id;
  final String fullName;
  final DateTime dob;
  final String gender;
  final String bloodGroup;
  final String allergies;
  final String emergencyContact; // Key for Parent Linking
  final String admissionNumber;
  final String classId;
  final String sectionId;
  final List<String> parentIds; // List of linked Parent UIDs
  final String? profilePhotoUrl;
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.allergies,
    required this.emergencyContact,
    required this.admissionNumber,
    required this.classId,
    required this.sectionId,
    this.parentIds = const [],
    this.profilePhotoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'dob': dob.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'admissionNumber': admissionNumber,
      'classId': classId,
      'sectionId': sectionId,
      'parentIds': parentIds,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(String id, Map<String, dynamic> map) {
    return Student(
      id: id,
      fullName: map['fullName'] ?? '',
      dob: DateTime.tryParse(map['dob'] ?? '') ?? DateTime.now(),
      gender: map['gender'] ?? 'Unknown',
      bloodGroup: map['bloodGroup'] ?? '',
      allergies: map['allergies'] ?? '',
      emergencyContact: map['emergencyContact'] ?? '',
      admissionNumber: map['admissionNumber'] ?? '',
      classId: map['classId'] ?? '',
      sectionId: map['sectionId'] ?? '',
      parentIds: List<String>.from(map['parentIds'] ?? []),
      profilePhotoUrl: map['profilePhotoUrl'],
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, fullName, sectionId, parentIds, emergencyContact];
}

// --- Logs ---

class DailyCare extends Equatable {
  final String id;
  final String studentId;
  final DateTime date;
  final Map<String, dynamic> food; // { "breakfast": "Ate well" }
  final Map<String, dynamic> hygiene; // { "nappy": true }
  final Map<String, dynamic> nap; // { "duration": 60 }

  const DailyCare({
    required this.id,
    required this.studentId,
    required this.date,
    required this.food,
    required this.hygiene,
    required this.nap,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'date': date.toIso8601String(),
      'food': food,
      'hygiene': hygiene,
      'nap': nap,
    };
  }

  factory DailyCare.fromMap(String id, Map<String, dynamic> map) {
    return DailyCare(
      id: id,
      studentId: map['studentId'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      food: Map<String, dynamic>.from(map['food'] ?? {}),
      hygiene: Map<String, dynamic>.from(map['hygiene'] ?? {}),
      nap: Map<String, dynamic>.from(map['nap'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, studentId, date];
}

class Activity extends Equatable {
  final String id;
  final String studentId; // or sectionId if group activity
  final String type; // Art, Music, etc.
  final String description;
  final List<String> photoUrls;
  final DateTime timestamp;

  const Activity({
    required this.id,
    required this.studentId,
    required this.type,
    required this.description,
    required this.photoUrls,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'type': type,
      'description': description,
      'photoUrls': photoUrls,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Activity.fromMap(String id, Map<String, dynamic> map) {
    return Activity(
      id: id,
      studentId: map['studentId'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, studentId, timestamp];
}
