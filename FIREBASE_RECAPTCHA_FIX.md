# 🔧 Fix Firebase reCAPTCHA Configuration Error

## Error: `CONFIGURATION_NOT_FOUND` for RecaptchaAction

This error occurs when Firebase App Check or reCAPTCHA is not properly configured. Here's how to fix it:

## Option 1: Disable App Check (Recommended for Development)

### Step 1: Firebase Console Settings
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `devmark-sample-login`
3. Go to **Authentication** > **Settings** > **General**
4. Scroll down to **App verification**
5. **Disable** "Enable reCAPTCHA for web applications"

### Step 2: Authentication Settings
1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Make sure **Email/Password** is enabled
3. Click on **Email/Password** provider
4. Check both options:
   - ✅ Enable
   - ✅ Email link (passwordless sign-in) - Optional
5. Click **Save**

### Step 3: Authorized Domains
1. In **Authentication** > **Settings** > **Authorized domains**
2. Make sure `localhost` is in the list (for development)
3. If testing on device, you might need to add your development domains

## Option 2: Properly Configure App Check (For Production)

If you want to use App Check in production:

### For Web (reCAPTCHA):
1. Go to **Project Settings** > **App Check**
2. Click **Register app** for your web app
3. Choose **reCAPTCHA v3**
4. Get your reCAPTCHA site key from [Google reCAPTCHA](https://www.google.com/recaptcha/admin/)
5. Add the site key to Firebase

### For Android (Play Integrity):
1. Enable Play Integrity API in Google Cloud Console
2. Configure Play Integrity provider in Firebase App Check

### For iOS (App Attest):
1. Configure App Attest provider in Firebase App Check

## Option 3: Debug Settings (Current Fix)

Your app now includes debug settings in `main.dart` that handle this error gracefully during development.

## Quick Test Steps:

1. **Disable reCAPTCHA in Firebase Console** (Option 1 above)
2. **Run your app:**
   ```bash
   flutter run
   ```
3. **Test signup with:**
   - Name: Test User
   - Email: test@example.com
   - Password: password123

## Expected Behavior After Fix:

- ✅ Signup should work without reCAPTCHA errors
- ✅ User should be created in Firebase Authentication
- ✅ User document should be created in Firestore
- ✅ Login should work with created credentials

## Production Notes:

- For production apps, enable App Check for security
- Use reCAPTCHA v3 for web applications
- Use Play Integrity for Android
- Use App Attest for iOS
- Monitor usage in Firebase Console

## If Error Persists:

1. Check Firebase project permissions
2. Verify your Firebase configuration in `firebase_options.dart`
3. Ensure your app bundle ID matches Firebase configuration
4. Try creating a new test project in Firebase Console

The error should be resolved after disabling reCAPTCHA in the Firebase Console!
