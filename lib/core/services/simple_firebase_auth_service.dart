import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SimpleFirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize auth settings to disable reCAPTCHA and web flows
  static Future<void> initialize() async {
    try {
      // Set auth settings to disable reCAPTCHA verification and web flows
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

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password (simplified)
  static Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Ensure auth is configured
      await initialize();
      
      // Create user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(fullName);
        
        // Create user document
        await _createUserDocument(user, fullName);
      }

      return user;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with email and password (simplified)
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Ensure auth is configured
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

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Create user document in Firestore
  static Future<void> _createUserDocument(User user, String fullName) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'fullName': fullName,
        'provider': 'email',
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to create user document: $e');
    }
  }
}
