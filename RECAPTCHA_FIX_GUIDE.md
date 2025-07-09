# Fix Firebase reCAPTCHA Configuration Error

## The Error
```
E/RecaptchaCallWrapper( 6638): Initial task failed for action RecaptchaAction(action=signUpPassword)with exception - An internal error has occurred. [ CONFIGURATION_NOT_FOUND ]
```

## Solution Steps

### 1. Disable reCAPTCHA in Firebase Console (Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `devmark-sample-login`
3. Go to **Authentication** > **Settings** tab
4. Scroll down to **"Advanced"** section
5. Find **"App verification"** settings
6. **Disable reCAPTCHA verification** for development

### 2. Alternative: Configure reCAPTCHA Properly

If you want to keep reCAPTCHA enabled:

1. In Firebase Console > **Authentication** > **Settings**
2. Go to **"App verification"** section
3. Add your domain to the **"Authorized domains"** list:
   - `localhost` (for local development)
   - Your actual domain (for production)

### 3. For Android Development

Add this to your `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <!-- Add this inside your application tag -->
    <meta-data
        android:name="com.google.firebase.auth.api_key"
        android:value="@string/default_web_client_id" />
</application>
```

### 4. Code-Level Fix (Already Applied)

The main.dart file has been updated to disable reCAPTCHA for development:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Disable reCAPTCHA for development
  if (kDebugMode) {
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );
  }
  
  runApp(const MyApp());
}
```

### 5. Quick Test Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# If still having issues, try with verbose logging
flutter run --verbose
```

### 6. Alternative Configuration

If the above doesn't work, you can also try this in your Firebase Console:

1. Go to **Authentication** > **Sign-in method**
2. Click on **Email/Password**
3. Make sure **"Email link (passwordless sign-in)"** is **DISABLED**
4. Save the changes

## Expected Result

After applying these fixes, you should be able to:
- Create new user accounts without reCAPTCHA errors
- Sign in existing users successfully
- See user data saved in Firestore database

## If Issues Persist

Try these additional steps:

1. **Regenerate Firebase config**:
   ```bash
   flutterfire configure
   ```

2. **Check Firebase project settings**:
   - Ensure your Android package name matches: `com.example.mobile_login`
   - Verify the `google-services.json` file is up to date

3. **Contact Firebase Support** if the error persists in production
