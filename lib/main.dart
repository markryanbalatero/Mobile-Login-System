import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configure Firebase Auth to prevent web-based flows on mobile
  if (!kIsWeb) {
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
      forceRecaptchaFlow: false,
    );
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        home: const AppView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Set different status bar styles based on the screen
        if (state.status == AuthStatus.authenticated) {
          // Home screen - dark status bar
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: AppColors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          );
        } else {
          // Login screen - light status bar (for dark background)
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: AppColors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          );
        }

        switch (state.status) {
          case AuthStatus.authenticated:
            return const HomeScreen();
          case AuthStatus.unauthenticated:
          case AuthStatus.initial:
          case AuthStatus.loading:
          case AuthStatus.error:
          case AuthStatus.signupSuccess:
            return const LoginScreen();
        }
      },
    );
  }
}
