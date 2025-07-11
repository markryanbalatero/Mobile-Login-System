part of 'login_form_cubit.dart';

class LoginFormState extends Equatable {
  const LoginFormState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isPasswordVisible = false,
  });

  final Email email;
  final Password password;
  final bool isValid;
  final bool isPasswordVisible;

  @override
  List<Object> get props => [email, password, isValid, isPasswordVisible];

  LoginFormState copyWith({
    Email? email,
    Password? password,
    bool? isValid,
    bool? isPasswordVisible,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
