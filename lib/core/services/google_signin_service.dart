import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Configure GoogleSignIn for mobile platforms only
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    // Force native sign-in for mobile platforms
    forceCodeForRefreshToken: !kIsWeb,
  );

  static Future<User?> signInWithGoogle() async {
    try {
      // Ensure we're not on web platform
      if (kIsWeb) {
        throw Exception('Web platform detected. Use Firebase Auth web flows instead.');
      }

      // Clear any existing sign-in session
      await _googleSignIn.signOut();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // If the user cancels the sign-in, return null
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Ensure we have both tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      final user = userCredential.user;
      if (user != null) {
        // Create or update user document in Firestore (non-blocking, ignore errors)
        _createOrUpdateUserDocument(user).then((_) {
          debugPrint('✅ Google user document created/updated successfully for: ${user.email}');
        }).catchError((e) {
          debugPrint('❌ Failed to create/update Google user document (non-fatal): $e');
        });
      }
      
      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow; // Re-throw to let caller handle the error
    }
  }

  static Future<void> signOut() async {
    try {
      // Always try to sign out from Google first (even if not signed in with Google)
      // This is safe to call even if user didn't sign in with Google
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Google sign out error (safe to ignore): $e');
      }
      
      // Then sign out from Firebase Auth
      await _auth.signOut();
      
      debugPrint('Successfully signed out from all services');
    } catch (e) {
      debugPrint('Error during sign out: $e');
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
      debugPrint('🔄 Creating/updating Google user document for: ${user.email}');
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        debugPrint('🆕 Creating new Google user document');
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
        debugPrint('🔄 Updating existing Google user document');
        // Update last sign in time for existing user
        await userDoc.update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      }
      debugPrint('✅ Google Firestore document operation completed for: ${user.email}');
    } catch (e) {
      debugPrint('❌ Failed to create/update Google user document: $e');
      rethrow; // Let the caller handle the error
    }
  }
}