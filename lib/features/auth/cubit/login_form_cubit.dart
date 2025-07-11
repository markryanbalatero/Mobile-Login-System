import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../core/models/email.dart';
import '../../../core/models/password.dart';

part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<String?> submitForm() async {
    if (!state.isValid) {
      return 'Please fill all fields correctly';
    }
    
    // Return the email and password for the AuthCubit to use
    return null; // Success - no error message
  }

  String get email => state.email.value;
  String get password => state.password.value;

  void clearForm() {
    emit(const LoginFormState());
  }
}
