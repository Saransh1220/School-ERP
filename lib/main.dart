import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'features/auth/domain/user_entity.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     // Disable persistence to force immediate server errors when DB is missing
     try {
       FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
     } catch (e) {
       print("Error setting persistence: $e");
     }
  } catch (e) {
     print("Firebase Init Error (Mocking for now): $e");
     // Fallback for development if file missing 
     if (Firebase.apps.isEmpty) {
        // await Firebase.initializeApp(); // Try default?
     }
  }
  runApp(const ProviderScope(child: SchoolApp()));
}

class SchoolApp extends ConsumerWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.value;

    return MaterialApp.router(
      title: 'School LMS',
      theme: user != null 
          ? ThemeFactory.getThemeForRole(user.role)
          : ThemeFactory.getThemeForRole(UserRole.parent), // Default
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
