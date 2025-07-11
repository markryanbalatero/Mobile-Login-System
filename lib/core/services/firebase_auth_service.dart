import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  static Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Configure auth settings to bypass reCAPTCHA
      await _configureAuthSettings();
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update last sign in time
      if (credential.user != null) {
        await _updateLastSignIn(credential.user!);
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign up with email and password
  static Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Configure auth settings to bypass reCAPTCHA
      await _configureAuthSettings();
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(fullName);

      // Create user document in Firestore
      if (credential.user != null) {
        await _createUserDocument(credential.user!, fullName);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Configure Firebase Auth to bypass reCAPTCHA
  static Future<void> _configureAuthSettings() async {
    try {
      if (kDebugMode) {
        await _auth.setSettings(
          appVerificationDisabledForTesting: true,
          forceRecaptchaFlow: false,
        );
      }
    } catch (e) {
      debugPrint('Auth settings configuration: $e');
    }
  }

  // Update last sign in timestamp
  static Future<void> _updateLastSignIn(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'lastSignIn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Failed to update last sign in: $e');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Send password reset email
  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  // Create user document in Firestore
  static Future<void> _createUserDocument(User user, String fullName) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'fullName': fullName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Log error but don't throw to prevent auth from failing
      debugPrint('Failed to create user document: $e');
    }
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    // Log the error for debugging
    debugPrint('Firebase Auth Error Code: ${e.code}');
    debugPrint('Firebase Auth Error Message: ${e.message}');
    
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      case 'configuration-not-found':
      case 'internal-error':
      case 'unknown':
        // These are often reCAPTCHA related - provide a user-friendly message
        if (e.message?.contains('CONFIGURATION_NOT_FOUND') == true ||
            e.message?.contains('reCAPTCHA') == true) {
          return 'Authentication service temporarily unavailable. Please try again.';
        }
        return 'An internal error occurred. Please try again.';
      case 'recaptcha-not-enabled':
      case 'missing-recaptcha-token':
      case 'invalid-recaptcha-token':
        return 'Security verification failed. Please try again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        // For any unknown errors, provide a generic message
        return 'Authentication failed. Please try again.';
    }
  }
}
