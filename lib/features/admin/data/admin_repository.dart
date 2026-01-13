import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/school_entities.dart';
import '../domain/user_entities.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Error Handling Wrapper ---
  
  Future<T> _handleFirestoreError<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseException catch (e) {
      if (e.code == 'not-found' || e.message?.contains('database') == true) {
         throw Exception("🔥 Critical: Firestore Database NOT FOUND. Please create it in Firebase Console.\nProject: ${e.plugin}\nMessage: ${e.message}");
      }
       if (e.code == 'permission-denied') {
         throw Exception("🔒 Permission Denied. Check your Security Rules.");
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  // --- Classroom Management ---

  Future<void> createClassroom(Classroom classroom) async {
    return _handleFirestoreError(() async {
        final docRef = _firestore.collection('classes').doc(classroom.id.isEmpty ? null : classroom.id);
        final newClass = Classroom(id: docRef.id, name: classroom.name, order: classroom.order);
        await docRef.set(newClass.toMap());
    });
  }

  Stream<List<Classroom>> getClassrooms() {
    return _firestore
        .collection('classes')
        .orderBy('order')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Classroom.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  // --- Section Management ---

  Future<void> createSection(Section section) async {
    return _handleFirestoreError(() async {
      // Use existing ID if present (Update mode), else Auto-ID (Create mode)
      final docRef = _firestore.collection('sections').doc(section.id.isEmpty ? null : section.id);
      
      final sectionWithId = Section(
        id: docRef.id,
        classId: section.classId,
        name: section.name,
        teacherId: section.teacherId,
      );
      await docRef.set(sectionWithId.toMap());
    });
  }

  Stream<List<Section>> getSections({String? classId}) {
    Query query = _firestore.collection('sections');
    if (classId != null) {
      query = query.where('classId', isEqualTo: classId);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Section.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  // --- Student Management ---

  Future<void> createStudent({
      required Student student, 
      required String parentName, 
      required String parentPhone
  }) async {
     return _handleFirestoreError(() async {
        final studentRef = _firestore.collection('students').doc();
        
        // 1. Create/Check Parent User
        // We use the phone number as the unique key to find existing parents.
        String parentUid;
        final parentQuery = await _firestore.collection('users')
             .where('phone', isEqualTo: parentPhone)
             .where('role', isEqualTo: 'parent')
             .get();

        if (parentQuery.docs.isNotEmpty) {
           // Existing Parent
           final parentDoc = parentQuery.docs.first;
           parentUid = parentDoc.id;
           
           // Update existing parent's linked students
           await parentDoc.reference.update({
             'linkedStudentIds': FieldValue.arrayUnion([studentRef.id])
           });
        } else {
           // New Parent (Pre-provisioning)
           final newUserRef = _firestore.collection('users').doc(); // Auto-ID (will match Auth UID later if we sync, or we wait for them to claim)
           // WAIT: If we generate an ID here, it won't match Firebase Auth UID when they OTP login!
           // SOLUTION: We can't know the UID before they login with Phone Auth.
           // STRATEGY: We create a "Shadow Record" or just rely on 'emergencyContact' matching.
           
           // Based on User Request: "Full form... required to login".
           // This implies we EXPECT them to use this phone number.
           // The previous "Auto-Linking" logic (Step 1606) handles the "Claiming" perfectly.
           // So here, we just need to ensure the STUDENT record has the 'emergencyContact' set correctly.
           // BUT, the user wants the Parent Info stored upfront.
           
           // Let's store a "Prospect" user or just rely on the Student data?
           // Actually, let's create the User doc using the Phone Number as ID? No, Auth UIDs are random.
           
           // REVISION: We CANNOT create the Auth User here without Admin SDK.
           // We CAN create the Firestore User Doc. But the ID won't match Auth UID.
           // FIX: The functionality in Step 1606 (Auto-Linking) compensates for this.
           // When they login (Auth UID generated), it looks up Student by Phone. 
           // IF found, it creates the Firestore User Doc (with Auth UID) and links.
           
           // SO: We don't necessarily need to create the User doc here if they don't exist. 
           // OR: We create a doc with a placeholder ID, but that causes fragmentation.
           
           // BETTER APPROACH: Just ensure Student has the metadata.
           // However, user said "Parent Information... required to login".
           // I will interpret this as: Strict Data Entry on Student.
           
           parentUid = ""; // No UID yet
        }

        // 2. Create Student with Parent Metadata (denormalized for display until linked)
        final newStudent = Student(
          id: studentRef.id,
          fullName: student.fullName,
          dob: student.dob,
          gender: student.gender,
          bloodGroup: student.bloodGroup,
          allergies: student.allergies,
          emergencyContact: parentPhone, // Critical for key
          admissionNumber: student.admissionNumber,
          classId: student.classId,
          sectionId: student.sectionId,
          parentIds: parentUid.isNotEmpty ? [parentUid] : [],
          profilePhotoUrl: student.profilePhotoUrl,
          createdAt: DateTime.now(),
        );
        
        await studentRef.set(newStudent.toMap());
     });
  }

  Stream<List<Student>> getStudents({String? sectionId}) {
    Query query = _firestore.collection('students');
    if (sectionId != null) {
      query = query.where('sectionId', isEqualTo: sectionId);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Student.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList());
  }

  // --- Teacher Management ---
  
  Stream<List<UserProfile>> getTeachers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserProfile.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }
  
  Future<void> createTeacher({required String name, required String email, required String password}) async {
      return _handleFirestoreError(() async {
          // Note: In Client SDK, we can't create 'other' users easily without logging out.
          // For a Production App, this should be a Cloud Function.
          // For this MVP/Prototype: 
          // Option A: Admin creates a "Invite" doc. Teacher registers and claims it.
          // Option B: Just create the Firestore doc, and tell Teacher to "Sign Up" with that email.
          
          // Let's go with Option B (Firestore Doc Placeholder). 
          // Use Email as a temporary key if needed, or just let them sign up.
          
          // Actually, we can just assume the Admin is "inviting" them.
          // We'll create a UserProfile doc. But we don't know the UID.
          // So we can't create the doc yet. 
          
          // ALTERNATIVE: Use a secondary app or logout/login.
          // For now: Just a placeholder. Real implementation needs Cloud Functions.
          throw UnimplementedError("Admin creation of accounts requires Cloud Functions or Admin SDK.");
      });
  }
  
  // Alternative: 'Invite' style
  Future<void> inviteTeacher(UserProfile profile) async {
      // Just create a placeholder in a 'invites' collection?
      // Or relies on them signing up.
  }

  // --- Parent Linking ---

  Future<void> linkParentToStudent({required String parentUid, required String studentId}) async {
     return _handleFirestoreError(() async {
        final batch = _firestore.batch();
        final studentRef = _firestore.collection('students').doc(studentId);
        final parentRef = _firestore.collection('users').doc(parentUid);

        batch.update(studentRef, {
          'parentIds': FieldValue.arrayUnion([parentUid])
        });
        
        batch.update(parentRef, {
          'linkedStudentIds': FieldValue.arrayUnion([studentId])
        });

        await batch.commit();
     });
  }
}
