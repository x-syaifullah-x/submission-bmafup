sealed class SignInException implements Exception {
  final String value;

  const SignInException(this.value);
}

class SignInInputEmailException extends SignInException {
  const SignInInputEmailException(super.value);
}

class SignInInputPasswordException extends SignInException {
  const SignInInputPasswordException(super.value);
}
