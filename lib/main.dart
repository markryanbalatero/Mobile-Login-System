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
import 'features/auth/screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) {
          print('🔄 MyApp: buildWhen - previous: ${previous.status}, current: ${current.status}');
          
          if (current.status == AuthStatus.loading) {
            print('⏳ MyApp: Skipping rebuild during loading state');
            return false;
          }
          
          return previous.status != current.status;
        },
        builder: (context, state) {
          print('🔄 MyApp: Building with auth status: ${state.status}');
          return MaterialApp(
            key: ValueKey(state.status),
            title: AppStrings.appTitle,
            theme: AppTheme.lightTheme,
            home: const AppView(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) {
        print('🔄 AppView: buildWhen - previous: ${previous.status}, current: ${current.status}');
        
        if (current.status == AuthStatus.loading) {
          print('⏳ AppView: Skipping rebuild during loading state');
          return false;
        }
        
        return previous.status != current.status;
      },
      builder: (context, state) {
        print('🔄 AppView Builder: Current auth status: ${state.status}');
        
        if (state.status == AuthStatus.authenticated) {
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: AppColors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          );
        } else {
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
            print('📱 AppView: Showing HomeScreen');
            return const HomeScreen();
          case AuthStatus.signupSuccess:
            print('🎉 AppView: Showing SignupScreen (for success snackbar)');
            return const SignupScreen();
          case AuthStatus.unauthenticated:
          case AuthStatus.initial:
          case AuthStatus.error:
          case AuthStatus.loading:
            print('🔑 AppView: Showing LoginScreen');
            return const LoginScreen();
        }
      },
    );
  }
}
