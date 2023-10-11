sealed class SignUpException implements Exception {
  final String value;

  const SignUpException(this.value);
}

class SignUpInputEmailException extends SignUpException {
  const SignUpInputEmailException(super.value);
}

class SignUpInputPhoneNumberException extends SignUpException {
  const SignUpInputPhoneNumberException(super.value);
}

class SignUpInputPasswordException extends SignUpException {
  const SignUpInputPasswordException(super.value);
}

class SignUpInputPasswordConfirmException extends SignUpException {
  const SignUpInputPasswordConfirmException(super.value);
}
