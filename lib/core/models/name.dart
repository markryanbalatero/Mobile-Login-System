import 'package:formz/formz.dart';

enum NameValidationError { empty, tooShort }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return NameValidationError.empty;
    } else if (value != null && value.trim().length < 2) {
      return NameValidationError.tooShort;
    }
    return null;
  }
}

extension NameValidationErrorX on NameValidationError {
  String get text {
    switch (this) {
      case NameValidationError.empty:
        return 'Full name is required';
      case NameValidationError.tooShort:
        return 'Full name must be at least 2 characters';
    }
  }
}
