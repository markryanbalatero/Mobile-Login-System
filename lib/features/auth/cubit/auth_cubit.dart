import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/simple_firebase_auth_service.dart';
import '../../../core/services/google_signin_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  bool _ignoreAuthStateChanges = false;

  AuthCubit() : super(const AuthState()) {
    SimpleFirebaseAuthService.initialize();
    
    SimpleFirebaseAuthService.authStateChanges.listen((User? user) {
      if (_ignoreAuthStateChanges) return;
      
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user.email ?? '',
          errorMessage: null,
        ));
      } else {
        _ignoreAuthStateChanges = false;
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          errorMessage: null,
        ));
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await SimpleFirebaseAuthService.signIn(
        email: email,
        password: password,
      );
      
      if (user != null) {
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to sign in',
        ));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      _ignoreAuthStateChanges = true;
      
      final user = await SimpleFirebaseAuthService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception('Account creation timed out. Please try again.');
        },
      );
      
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.signupSuccess,
          user: user.email ?? '',
          errorMessage: null,
        ));
      } else {
        _ignoreAuthStateChanges = false;
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Failed to create account',
        ));
      }
    } catch (e) {
      _ignoreAuthStateChanges = false;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> signOut() async {
    print('🚪 Starting logout process...');
    emit(state.copyWith(status: AuthStatus.loading));
    
    try {
      print('📱 Calling GoogleSignInService.signOut()...');
      await GoogleSignInService.signOut().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏰ Logout timeout after 10 seconds');
          throw Exception('Logout timed out. Please try again.');
        },
      );
      
      print('✅ GoogleSignInService.signOut() completed successfully');
      
      print('🔄 Emitting unauthenticated state...');
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      ));
      print('✅ Unauthenticated state emitted successfully');
      
    } catch (e) {
      print('💥 Logout error: $e');
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> completeSignupFlow() async {
    try {
      await SimpleFirebaseAuthService.signOut();
      _ignoreAuthStateChanges = false;
      
    } catch (e) {
      _ignoreAuthStateChanges = false;
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await GoogleSignInService.signInWithGoogle();
      
      if (user != null) {
      } else {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Google sign-in was cancelled',
        ));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: _getErrorMessage(e),
        ),
      );
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'The account already exists for that email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is not valid.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return 'An error occurred. Please try again.';
  }

  void clearError() {
    emit(
      state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null),
    );
  }
}
