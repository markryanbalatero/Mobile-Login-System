import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return PasswordValidationError.empty;
    } else if (value != null && value.length < 6) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}

extension PasswordValidationErrorX on PasswordValidationError {
  String get text {
    switch (this) {
      case PasswordValidationError.empty:
        return 'Password is required';
      case PasswordValidationError.tooShort:
        return 'Password must be at least 6 characters';
    }
  }
}
