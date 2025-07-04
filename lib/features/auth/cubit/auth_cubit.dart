import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simple validation for demo
      if (email.isNotEmpty && password.isNotEmpty) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: email));
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Invalid credentials',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Login failed. Please try again.',
        ),
      );
    }
  }

  void signOut() {
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      ),
    );
  }

  void clearError() {
    emit(
      state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null),
    );
  }
}
