class SignUpInput {
  final String name;
  final String email;
  final String password;
  final String passwordConfirm;
  final String phoneNumber;
  final bool agreementAndPrivacyPolicy;

  const SignUpInput({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.passwordConfirm,
    required this.agreementAndPrivacyPolicy,
  });
}
