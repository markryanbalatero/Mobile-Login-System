import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/simple_firebase_auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  bool _ignoreAuthStateChanges = false;

  AuthCubit() : super(const AuthState()) {
    // Initialize the simplified Firebase service
    SimpleFirebaseAuthService.initialize();
    
    // Listen to auth state changes
    SimpleFirebaseAuthService.authStateChanges.listen((User? user) {
      // Don't emit authentication changes during signup success flow
      if (_ignoreAuthStateChanges) return;
      
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user.email ?? '',
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
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
        // State will be updated by the auth state listener
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
      // Temporarily ignore auth state changes to prevent automatic navigation
      _ignoreAuthStateChanges = true;
      
      final user = await SimpleFirebaseAuthService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      
      if (user != null) {
        // Emit signup success state instead of authenticated
        emit(state.copyWith(
          status: AuthStatus.signupSuccess,
          user: user.email ?? '',
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
    try {
      await SimpleFirebaseAuthService.signOut();
      // State will be updated by the auth state listener
    } catch (e) {
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
      // Sign out the user and re-enable auth state listening
      await SimpleFirebaseAuthService.signOut();
      _ignoreAuthStateChanges = false;
      
      // The auth state listener will emit unauthenticated state
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
