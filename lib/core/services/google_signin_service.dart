import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<User?> signInWithGoogle() async {
    try {
      // Create a GoogleAuthProvider instance
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      
      // Add additional scopes if needed
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      
      // You can also add custom parameters
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });

      // Sign in with Firebase Auth using Google provider
      final UserCredential userCredential = await _auth.signInWithProvider(googleProvider);
      
      final user = userCredential.user;
      if (user != null) {
        // Create or update user document in Firestore
        await _createOrUpdateUserDocument(user);
      }
      
      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow; // Re-throw to let caller handle the error
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static bool isSignedIn() {
    return _auth.currentUser != null;
  }

  // Create or update user document in Firestore
  static Future<void> _createOrUpdateUserDocument(User user) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        // Create new user document
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'fullName': user.displayName ?? 'Google User',
          'photoURL': user.photoURL,
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      } else {
        // Update last sign in time for existing user
        await userDoc.update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('Failed to create/update user document: $e');
      // Don't throw here to prevent auth from failing
    }
  }
}