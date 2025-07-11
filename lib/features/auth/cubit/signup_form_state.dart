part of 'signup_form_cubit.dart';

class SignupFormState extends Equatable {
  const SignupFormState({
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isPasswordVisible = false,
  });

  final Name name;
  final Email email;
  final Password password;
  final bool isValid;
  final bool isPasswordVisible;

  @override
  List<Object> get props => [name, email, password, isValid, isPasswordVisible];

  SignupFormState copyWith({
    Name? name,
    Email? email,
    Password? password,
    bool? isValid,
    bool? isPasswordVisible,
  }) {
    return SignupFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
