import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleSignInService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    forceCodeForRefreshToken: !kIsWeb,
  );

  static Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        throw Exception('Web platform detected. Use Firebase Auth web flows instead.');
      }

      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      final user = userCredential.user;
      if (user != null) {
        _createOrUpdateUserDocument(user).then((_) {
          debugPrint('✅ Google user document created/updated successfully for: ${user.email}');
        }).catchError((e) {
          debugPrint('❌ Failed to create/update Google user document (non-fatal): $e');
        });
      }
      
      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Google sign out error (safe to ignore): $e');
      }
      
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

  static Future<void> _createOrUpdateUserDocument(User user) async {
    try {
      debugPrint('🔄 Creating/updating Google user document for: ${user.email}');
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        debugPrint('🆕 Creating new Google user document');
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
        await userDoc.update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      }
      debugPrint('✅ Google Firestore document operation completed for: ${user.email}');
    } catch (e) {
      debugPrint('❌ Failed to create/update Google user document: $e');
      rethrow;
    }
  }
}