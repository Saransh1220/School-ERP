import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final userDocRef = _firestore.collection('users').doc(firebaseUser.uid);
        final userDoc = await userDocRef.get();
        
        if (userDoc.exists) {
          final data = userDoc.data()!;
          return UserEntity(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            role: _parseRole(data['role']),
            name: data['fullName'] ?? firebaseUser.displayName ?? 'User',
          );
        } else {
          // New User: Check if they are a parent invited via Phone Number
          UserRole role = UserRole.parent;
          List<String> linkedStudentIds = [];
          String fullName = firebaseUser.displayName ?? 'New Parent';

          if (firebaseUser.phoneNumber != null) {
             final studentsQuery = await _firestore.collection('students')
                .where('emergencyContact', isEqualTo: firebaseUser.phoneNumber)
                .get();
             
             if (studentsQuery.docs.isNotEmpty) {
                // Determine name from first student or just default
                print("✅ Found ${studentsQuery.docs.length} students linked to this phone.");
                for (var doc in studentsQuery.docs) {
                   linkedStudentIds.add(doc.id);
                   // Auto-link parent to student too (bi-directional)
                   await doc.reference.update({
                      'parentIds': FieldValue.arrayUnion([firebaseUser.uid])
                   });
                }
             }
          }
          
          // Create the User Profile automatically
          await userDocRef.set({
             'uid': firebaseUser.uid,
             'phone': firebaseUser.phoneNumber,
             'email': firebaseUser.email,
             'role': 'parent',
             'fullName': fullName,
             'linkedStudentIds': linkedStudentIds,
             'createdAt': FieldValue.serverTimestamp(),
          });
          
          return UserEntity(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            role: role,
            name: fullName,
          );
        }
      } catch (e) {
        print("Error fetching/creating user role: $e");
        // Return a safe default so app doesn't crash, but logged out effectively
        return UserEntity(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            role: UserRole.parent,
            name: 'User',
        );
      }
    });
  }

  UserRole _parseRole(String? roleStr) {
    switch (roleStr) {
      case 'admin': return UserRole.admin;
      case 'teacher': return UserRole.teacher;
      case 'parent': return UserRole.parent;
      default: return UserRole.parent;
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(Exception e) onVerificationFailed,
    required Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onCodeAutoRetrievalTimeout(verificationId);
      },
    );
  }

  @override
  Future<void> signInWithSmsCode({required String verificationId, required String smsCode}) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
