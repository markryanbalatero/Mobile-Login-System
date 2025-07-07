import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import '../../../core/models/name.dart';
import '../../../core/models/email.dart';
import '../../../core/models/password.dart';

part 'signup_form_state.dart';

class SignupFormCubit extends Cubit<SignupFormState> {
  SignupFormCubit() : super(const SignupFormState());

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
      name: name,
      isValid: Formz.validate([name, state.email, state.password]),
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      isValid: Formz.validate([state.name, email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      isValid: Formz.validate([state.name, state.email, password]),
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<String?> submitForm() async {
    if (!state.isValid) {
      return 'Please fill all fields correctly';
    }
    
    // Return null for success - no error message
    return null;
  }

  String get fullName => state.name.value;
  String get email => state.email.value;
  String get password => state.password.value;

  void clearForm() {
    emit(const SignupFormState());
  }
}
