import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SimpleFirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    try {
      if (!kIsWeb) {
        await _auth.setSettings(
          appVerificationDisabledForTesting: true,
          forceRecaptchaFlow: false,
        );
      }
    } catch (e) {
      debugPrint('Failed to configure auth settings: $e');
    }
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await initialize();
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Account creation timed out. Please try again.');
        },
      );

      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
        
        _createUserDocument(user, fullName).then((_) {
          debugPrint('✅ User document created successfully for: ${user.email}');
        }).catchError((e) {
          debugPrint('❌ Failed to create user document (non-fatal): $e');
        });
      }

      return user;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await initialize();
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> _createUserDocument(User user, String fullName) async {
    try {
      debugPrint('🔄 Creating user document for: ${user.email}');
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'fullName': fullName,
        'provider': 'email',
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Firestore document creation completed for: ${user.email}');
    } catch (e) {
      debugPrint('❌ Failed to create user document: $e');
      rethrow;
    }
  }
}
