sealed class UpdateInput {}

class UpdateTypeName extends UpdateInput {
  final String name;

  UpdateTypeName(this.name);
}

class UpdateTypeEmail extends UpdateInput {
  final String email;

  UpdateTypeEmail(this.email);
}

class UpdateTypePhoneNumber extends UpdateInput {
  final String phoneNumber;

  UpdateTypePhoneNumber(this.phoneNumber);
}

class UpdateTypePassword extends UpdateInput {
  final String password;

  UpdateTypePassword(this.password);
}
