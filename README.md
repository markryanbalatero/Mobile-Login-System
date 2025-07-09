# 🚀 Mobile Login System - Flutter Firebase Authentication

A complete Flutter application with Firebase Authentication, featuring email/password login, Google Sign-in, and Firestore database integration.

## ✨ Features

### 🔐 Authentication
- **Email & Password Registration/Login**
- **Google Sign-in Integration** (Firebase Auth)
- **Automatic session management**
- **Secure error handling**
- **reCAPTCHA bypass for development**

### 🗄️ Database
- **Firestore user profiles**
- **Automatic user document creation**
- **Real-time authentication state**
- **Timestamps for user activity**

### 🎨 UI/UX
- **Beautiful, modern interface**
- **Smooth animations and transitions**
- **Loading states and error handling**
- **Responsive design**

## 🛠️ Setup Instructions

### 1. Firebase Configuration

1. **Create Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project: `your-project-name`
   - Enable Google Analytics (optional)

2. **Enable Authentication**:
   - Go to **Authentication** > **Sign-in method**
   - Enable **Email/Password**
   - Enable **Google Sign-in** (enter support email)

3. **Setup Firestore**:
   - Go to **Firestore Database**
   - Create database in **test mode**
   - Select your preferred location

4. **Add Apps to Firebase**:
   
   **For Android**:
   - Add Android app with package: `com.example.mobile_login`
   - Download `google-services.json` → `android/app/`
   
   **For iOS**:
   - Add iOS app with bundle ID: `com.example.mobileLogin`
   - Download `GoogleService-Info.plist` → `ios/Runner/`

### 2. Flutter Setup

```bash
# Install dependencies
flutter pub get

# Clean build (if needed)
flutter clean
flutter pub get

# Run the app
flutter run
```

### 3. Google Sign-in Configuration

**Android** (`android/app/build.gradle.kts`):
```kotlin
android {
    defaultConfig {
        applicationId "com.example.mobile_login"
        minSdk 23
        // ... other configs
    }
}
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleIdentifier</key>
<string>com.example.mobileLogin</string>
```

### 4. Testing the App

1. **Email/Password Flow**:
   - Create account: Enter name, email, password
   - Login: Use same credentials
   - Check Firebase Console for user creation

2. **Google Sign-in Flow**:
   - Tap "Sign in with Google"
   - Select Google account
   - Automatic user document creation

3. **Database Verification**:
   - Check **Authentication** > **Users**
   - Check **Firestore** > **users** collection

## 📱 Screenshots

| Login Screen | Signup Screen | Home Screen |
|--------------|---------------|-------------|
| ![Login](screenshot1.png) | ![Signup](screenshot2.png) | ![Home](screenshot3.png) |

## 🗂️ Project Structure

```
lib/
├── core/
│   ├── constants/     # App strings and constants
│   ├── models/        # Data models (Email, Password, Name)
│   ├── services/      # Firebase & Google Sign-in services
│   └── theme/         # App colors, text styles, theme
├── features/
│   └── auth/
│       ├── cubit/     # State management (Auth & Form Cubits)
│       └── screens/   # Login & Signup screens
├── shared/
│   ├── animations/    # Custom animations
│   └── widgets/       # Reusable UI components
└── screens/           # App screens (Home, etc.)
```

## 🔧 Key Components

### Services
- **`FirebaseAuthService`**: Email/password authentication
- **`GoogleSignInService`**: Google Sign-in with Firestore integration
- **`SimpleFirebaseAuthService`**: Simplified auth with reCAPTCHA bypass

### State Management
- **`AuthCubit`**: Global authentication state
- **`LoginFormCubit`**: Login form validation
- **`SignupFormCubit`**: Signup form validation

### UI Components
- **`GoogleSignInButton`**: Styled Google Sign-in button
- **`CustomButton`**: Reusable primary buttons
- **`CustomTextFormField`**: Styled form inputs
- **`OrDivider`**: Separator with text

## 🔒 Security Features

- **Firestore Security Rules**: Users can only access their own data
- **reCAPTCHA disabled** for development (configurable)
- **App verification** settings for production
- **Proper error handling** without exposing sensitive info

## 🚨 Troubleshooting

### Common Issues:

1. **Google Sign-in not working**:
   - Verify Firebase project configuration
   - Check if Google Sign-in is enabled in Firebase Console
   - Ensure correct package name/bundle ID

2. **reCAPTCHA errors**:
   - Disable reCAPTCHA in Firebase Console for development
   - Check `main.dart` for auth settings configuration

3. **Build errors**:
   - Run `flutter clean && flutter pub get`
   - Update dependencies if needed
   - Check platform-specific configurations

### Debug Commands:
```bash
# Check Firebase configuration
flutterfire configure

# Verbose logging
flutter run --verbose

# Clean rebuild
flutter clean
flutter pub get
flutter run
```

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6      # State management
  firebase_core: ^3.8.0     # Firebase core
  firebase_auth: ^5.6.2     # Firebase authentication (includes Google Sign-in)
  cloud_firestore: ^5.5.0   # Firestore database
  formz: ^0.7.0             # Form validation
  google_fonts: ^6.2.1      # Custom fonts
```

## 🔮 Future Enhancements

- [ ] Apple Sign-in integration
- [ ] Phone number authentication
- [ ] Email verification
- [ ] Password reset functionality
- [ ] Multi-factor authentication
- [ ] Profile management
- [ ] Dark theme support

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

---

⭐ **Star this repo** if you found it helpful! 