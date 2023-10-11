import 'package:submission/data/exceptions/sign_in_exception.dart';
import 'package:submission/data/exceptions/sign_up_exception.dart';
import 'package:submission/data/models/sign_up_input.dart';
import 'package:submission/data/models/update_input.dart';
import 'package:submission/data/models/user.dart';
import 'package:submission/data/results.dart';

class UserRepository {
  UserRepository._();

  static UserRepository? _instance;

  static UserRepository getInstance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = UserRepository._();
      return _instance!;
    }
  }

  final _users = <String, User>{};
  User? _currentUser;

  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  Future<Result<User>> signup(SignUpInput input) async {
    try {
      for (var element in _users.entries) {
        User value = element.value;
        if (value.email == input.email) {
          return ResultError(
            Exception("User has been registered"),
          );
        }
      }
      if (!_isEmail(input.email)) {
        return const ResultError(
          SignUpInputEmailException("Please input correct email address"),
        );
      }
      if (input.phoneNumber.isEmpty) {
        return const ResultError(
          SignUpInputPhoneNumberException("Mobile number cannot be empty"),
        );
      }
      if (input.password.isEmpty) {
        return const ResultError(
          SignUpInputPasswordException("Password is too short"),
        );
      }
      if (input.password != input.passwordConfirm) {
        return const ResultError(
          SignUpInputPasswordConfirmException(
            "The password does not match. Try again",
          ),
        );
      }
      User user = User(
        name: input.name,
        email: input.email,
        password: input.password,
        phoneNumber: input.phoneNumber,
        agreementAndPrivacyPolicy: input.agreementAndPrivacyPolicy,
      );
      String key = _getUserKey(user);
      _users[key] = user;
      User? result = _users[key];
      if (result != null) {
        _currentUser = result;
        return ResultSuccess(result);
      }
      return ResultError(Exception("Failed to register"));
    } catch (e) {
      return ResultError(Exception(e));
    }
  }

  Future<Result<User>> signIn({
    required String email,
    required String password,
    bool isRemember = false,
  }) async {
    if (!_isEmail(email)) {
      return const ResultError(
        SignInInputEmailException("Please input correct email address"),
      );
    }
    if (password.isEmpty) {
      return const ResultError(
        SignInInputPasswordException("The password cannot be empty"),
      );
    }
    String key = _getUserKeyWithEmailAndPassword(email, password);
    User? user = _users[key];
    if (user != null) {
      _currentUser = user;
      return ResultSuccess(user);
    }
    return ResultError(
      Exception("User not register"),
    );
  }

  Future<Result<bool>> signOut() async {
    try {
      _currentUser = null;
      return ResultSuccess(
        _currentUser == null,
      );
    } catch (e) {
      return ResultError(
        Exception(e),
      );
    }
  }

  Future<Result> update(UpdateInput input) async {
    try {
      final currentUser = await getCurrentUser();

      if (currentUser == null) {
        return ResultError(
          Exception("User is null"),
        );
      }

      User userUpdate;

      switch (input) {
        case UpdateTypeName():
          String name = input.name;
          if (name.isEmpty) {
            return ResultError(Exception("Please enter your name"));
          }
          userUpdate = currentUser.copyWith(name: name);
          break;
        case UpdateTypeEmail():
          String email = input.email;
          if (!_isEmail(email)) {
            return ResultError(
              Exception("Please enter correct email address"),
            );
          }
          userUpdate = currentUser.copyWith(email: email);
        case UpdateTypePhoneNumber():
          String phoneNumber = input.phoneNumber;
          if (phoneNumber.isEmpty) {
            return ResultError(
              Exception("Please enter your phone number"),
            );
          }
          userUpdate = currentUser.copyWith(phoneNumber: phoneNumber);
        case UpdateTypePassword():
          String password = input.password;
          if (password.isEmpty) {
            return ResultError(
              Exception("Please enter your password"),
            );
          }
          userUpdate = currentUser.copyWith(password: password);
      }

      String userKeyOld = _getUserKey(currentUser);
      User? resultRemove = _users.remove(userKeyOld);
      if (resultRemove == null) {
        return ResultError(
          Exception("No users have been updated"),
        );
      }
      String userKeyNew = _getUserKey(userUpdate);
      _users[userKeyNew] = userUpdate;
      _currentUser = userUpdate;
      return const ResultSuccess(null);
    } catch (e) {
      return ResultError(
        Exception(e),
      );
    }
  }

  Future<Result<String>> forgetPassword(String email) async {
    if (!_isEmail(email)) {
      return ResultError(
        Exception("Please input correct email address"),
      );
    }
    for (var value in _users.values) {
      if (email == value.email) {
        return ResultSuccess(value.password);
      }
    }
    return ResultError(
      Exception("Your email is not registered yet"),
    );
  }

  String _getUserKey(User user) =>
      _getUserKeyWithEmailAndPassword(user.email, user.password);

  String _getUserKeyWithEmailAndPassword(String email, String password) =>
      "email: $email|| password: $password";

  bool _isEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }
}
