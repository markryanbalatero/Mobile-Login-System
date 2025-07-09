# Firebase Setup Guide for Mobile Login System

## Step 1: Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project with a unique name (e.g., "mobile-login-system-2025")
3. Enable Google Analytics (optional)

## Step 2: Enable Authentication

1. In your Firebase project, go to **Authentication** > **Sign-in method**
2. Enable **Email/Password** authentication
3. Optionally enable other sign-in methods as needed

## Step 3: Set up Firestore Database

1. Go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location closest to your users

## Step 4: Add Firebase to your Flutter app

### For Android:
1. In Firebase Console, click **Add app** > **Android**
2. Enter your Android package name: `com.example.mobile_login`
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Add the following to `android/build.gradle` (project level):
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.4.0'
   }
   ```
6. Add to `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   
   dependencies {
       implementation platform('com.google.firebase:firebase-bom:32.7.0')
   }
   ```

### For iOS:
1. In Firebase Console, click **Add app** > **iOS**
2. Enter your iOS bundle ID: `com.example.mobileLogin`
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` directory in Xcode
5. Make sure it's added to the target

### For Web:
1. In Firebase Console, click **Add app** > **Web**
2. Copy the Firebase configuration
3. Update `lib/firebase_options.dart` with your actual values

## Step 5: Update firebase_options.dart

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration:

```dart
// Get these values from your Firebase project settings
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-android-api-key',
  appId: 'your-actual-android-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-project-id.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'your-actual-ios-api-key',
  appId: 'your-actual-ios-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-project-id.appspot.com',
  iosBundleId: 'com.example.mobileLogin',
);
```

## Step 6: Configure App IDs

### Android (`android/app/build.gradle`):
```gradle
android {
    defaultConfig {
        applicationId "com.example.mobile_login"
        // ... other configs
    }
}
```

### iOS (`ios/Runner/Info.plist`):
```xml
<key>CFBundleIdentifier</key>
<string>com.example.mobileLogin</string>
```

## Step 7: Testing Firebase Connection

1. Run your app: `flutter run`
2. Try creating a new account
3. Check Firebase Console > Authentication to see if users are created
4. Check Firestore to see if user documents are created

## Step 8: Security Rules (Important!)

### Firestore Rules (`firestore.rules`):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Troubleshooting

### Common Issues:
1. **App not connecting to Firebase**: Check if `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) are in the correct locations
2. **Build errors**: Make sure all dependencies are up to date
3. **Authentication not working**: Verify Email/Password is enabled in Firebase Console
4. **Firestore errors**: Check security rules and make sure Firestore is initialized

### Debug Commands:
```bash
# Check Firebase project
firebase projects:list

# Re-configure if needed
flutterfire configure

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Production Checklist

Before going to production:
- [ ] Update Firestore security rules
- [ ] Enable App Check for additional security
- [ ] Set up proper error logging
- [ ] Configure email templates in Authentication settings
- [ ] Set up proper backup strategies
- [ ] Monitor usage and set up billing alerts
