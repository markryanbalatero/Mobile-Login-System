# 🔐 Google Sign-in Implementation Guide (Firebase Auth)

## 📋 Overview

This guide explains the Firebase Auth-based Google Sign-in implementation in your Flutter app. This approach uses Firebase Auth's built-in `GoogleAuthProvider` instead of the direct `google_sign_in` package, providing better integration and avoiding API compatibility issues.

## 🏗️ Architecture

### Components Involved:
1. **`GoogleSignInService`** - Firebase Auth Google provider integration
2. **`AuthCubit`** - State management for authentication
3. **`GoogleSignInButton`** - UI component
4. **Firestore Integration** - User data persistence

## 🔧 Implementation Details

### 1. Google Sign-in Service (`lib/core/services/google_signin_service.dart`)

```dart
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
      
      // Optional: Add custom parameters
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });

      // Sign in with Firebase Auth using Google provider
      final UserCredential userCredential = await _auth.signInWithProvider(googleProvider);
      
      final user = userCredential.user;
      if (user != null) {
        await _createOrUpdateUserDocument(user);
      }
      
      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }
}
```

#### Key Features:
- ✅ **No external dependencies** - Uses Firebase Auth only
- ✅ **Consistent error handling** - Unified with email/password auth
- ✅ **Automatic token management** - Firebase handles refresh tokens
- ✅ **Platform integration** - Works across web, iOS, Android

### 2. Firestore Integration

```dart
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
```

#### Database Schema:
```json
{
  "users": {
    "{user_uid}": {
      "uid": "string",
      "email": "string", 
      "fullName": "string",
      "photoURL": "string",
      "provider": "google",
      "createdAt": "timestamp",
      "lastSignIn": "timestamp"
    }
  }
}
```

### 3. State Management (`AuthCubit`)

```dart
Future<void> signInWithGoogle() async {
  emit(state.copyWith(status: AuthStatus.loading));

  try {
    final user = await GoogleSignInService.signInWithGoogle();
    
    if (user != null) {
      // Success - user authenticated
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user.email ?? '',
      ));
    } else {
      // User canceled the sign-in
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      ));
    }
  } catch (e) {
    // Error occurred
    emit(state.copyWith(
      status: AuthStatus.error,
      errorMessage: _getErrorMessage(e),
    ));
  }
}
```

### 4. UI Integration

```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return GoogleSignInButton(
      onPressed: state.status == AuthStatus.loading 
        ? null 
        : () => context.read<AuthCubit>().signInWithGoogle(),
      isLoading: state.status == AuthStatus.loading,
    );
  },
)
```

## ⚙️ Configuration

### 1. Firebase Console Setup

1. **Enable Google Sign-in**:
   - Go to Firebase Console > Authentication > Sign-in method
   - Enable **Google** provider
   - Enter support email (required)
   - Note the **Web client ID** if needed

2. **Configure OAuth**:
   - The OAuth client is automatically created
   - For custom scopes, configure in Google Cloud Console

### 2. Platform Configuration

#### Android (`android/app/build.gradle`):
```gradle
android {
    defaultConfig {
        applicationId "com.example.mobile_login"
        // ... other configs
    }
}
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<key>CFBundleIdentifier</key>
<string>com.example.mobileLogin</string>
```

#### Web:
- No additional configuration needed
- Firebase Auth handles the OAuth flow

### 3. Dependencies

```yaml
dependencies:
  firebase_core: ^3.8.0
  firebase_auth: ^5.6.2
  cloud_firestore: ^5.5.0
  # Note: google_sign_in package is NOT needed
```

## 🎯 Advantages of Firebase Auth Approach

### ✅ Benefits:
1. **Simplified Dependencies** - No external Google Sign-in package needed
2. **Unified Auth Flow** - Same patterns as email/password authentication
3. **Automatic Token Management** - Firebase handles token refresh
4. **Cross-Platform** - Works consistently across web, iOS, Android
5. **Better Error Handling** - Unified Firebase Auth exceptions
6. **Future-Proof** - Less likely to break with API changes

### 🔄 Migration from google_sign_in:
- ✅ **Removed** `google_sign_in: ^7.1.0` dependency
- ✅ **Simplified** authentication flow
- ✅ **Maintained** same Firestore integration
- ✅ **Kept** same UI components

## 🚀 Testing

### 1. Basic Flow Test:
```bash
flutter run
# Tap "Sign in with Google"
# Select Google account
# Verify user creation in Firebase Console
```

### 2. Error Scenarios:
- Network disconnection
- User cancellation
- Invalid Firebase configuration

### 3. Database Verification:
- Check Firebase Console > Authentication > Users
- Check Firestore > users collection
- Verify user document structure

## 🔧 Troubleshooting

### Common Issues:

1. **"Failed to launch URL"**:
   - Verify Firebase project configuration
   - Check OAuth client setup in Google Cloud Console

2. **"CONFIGURATION_NOT_FOUND"**:
   - Ensure Google Sign-in is enabled in Firebase Console
   - Verify `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)

3. **"Network error"**:
   - Check internet connection
   - Verify Firebase project is active

### Debug Steps:
```bash
# Verify Firebase configuration
flutterfire configure

# Clean rebuild
flutter clean && flutter pub get

# Verbose logging
flutter run --verbose
```

## 📱 Platform-Specific Notes

### Web:
- Uses popup-based OAuth flow
- No additional configuration needed
- Works with Firebase Hosting

### Android:
- Uses Android Account Chooser
- Requires `google-services.json`
- Works with release builds

### iOS:
- Uses iOS Account Chooser
- Requires `GoogleService-Info.plist`
- Works with App Store builds

## 🔮 Advanced Configuration

### Custom Scopes:
```dart
googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
```

### Custom Parameters:
```dart
googleProvider.setCustomParameters({
  'login_hint': 'user@example.com',
  'hd': 'example.com' // Restrict to domain
});
```

### Error Handling:
```dart
try {
  final user = await GoogleSignInService.signInWithGoogle();
} on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'account-exists-with-different-credential':
      // Handle account linking
      break;
    case 'invalid-credential':
      // Handle invalid credentials
      break;
    // ... other cases
  }
}
```

This implementation provides a robust, maintainable Google Sign-in solution that's fully integrated with your Firebase authentication system! 