class User {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final bool agreementAndPrivacyPolicy;

  const User({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.agreementAndPrivacyPolicy,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    bool? agreementAndPrivacyPolicy,
  }) =>
      User(
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        agreementAndPrivacyPolicy:
            agreementAndPrivacyPolicy ?? this.agreementAndPrivacyPolicy,
      );
}
