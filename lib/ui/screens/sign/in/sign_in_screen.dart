import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:submission/data/exceptions/sign_in_exception.dart';
import 'package:submission/data/repository/user_repository.dart';
import 'package:submission/data/results.dart';
import 'package:submission/ui/screens/home/home_screen.dart';
import 'package:submission/ui/screens/sign/in/alert_dialog_forget_password.dart';
import 'package:submission/ui/screens/sign/up/sign_up_screen.dart';
import 'package:submission/ui/utils/utils.dart';
import 'package:submission/ui/widgets/sign_text_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _textEditingControllerEmail = TextEditingController();
  final _textEditingControllerPassword = TextEditingController();
  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();

  String? _errorMessageEmail;
  String? _errorMessagePassword;

  bool _isRemember = true;
  bool _isObscureTextPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerText(),
        _emailAddressTextField(),
        _passwordTextField(),
        _sizeBoxHeight20(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: _rememberMeCheckbox()),
            const SizedBox(width: 4),
            Flexible(child: _forgetPasswordTextButton(context)),
          ],
        ),
        _sizeBoxHeight20(),
        _signInButton(context),
        _noHaveAccountText(context)
      ],
    );
  }

  Widget _headerText() {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 45),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi, Welcome Back!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Hello again, you've been missed!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _forgetPasswordTextButton(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Forget Password?    ",
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            showDialog(
              context: context,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (context) {
                return const AlertDialogForgetPassword();
              },
            );
          },
      ),
    );
  }

  Widget _rememberMeCheckbox() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: _isRemember,
          visualDensity: VisualDensity.compact,
          onChanged: (isChecked) =>
              setState(() => _isRemember = isChecked ?? false),
        ),
        Flexible(
          child: GestureDetector(
            child: const Text(
              "Remember Me",
              style: TextStyle(fontSize: 12),
            ),
            onTap: () => setState(() => _isRemember = !_isRemember),
          ),
        ),
      ],
    );
  }

  Widget _passwordTextField() {
    return SignTextField(
      label: "Password",
      hint: "Enter your password",
      controller: _textEditingControllerPassword,
      obscureText: _isObscureTextPassword,
      errorText: _errorMessagePassword,
      focusNode: _focusNodePassword,
      textInputAction: TextInputAction.done,
      suffixIcon: IconButton(
        icon: Icon(
          _isObscureTextPassword ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () => setState(() {
          _isObscureTextPassword = !_isObscureTextPassword;
        }),
      ),
      onChange: (value) {
        if (_errorMessagePassword != null) {
          setState(() => _errorMessagePassword = null);
        }
      },
    );
  }

  Widget _emailAddressTextField() {
    return SignTextField(
      label: "Email Address",
      hint: "Enter your email address",
      controller: _textEditingControllerEmail,
      errorText: _errorMessageEmail,
      focusNode: _focusNodeEmail,
      onChange: (value) {
        if (_errorMessageEmail != null) {
          setState(() => _errorMessageEmail = null);
        }
      },
    );
  }

  Widget _noHaveAccountText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Don't have an account?",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: " Signup",
              style: const TextStyle(
                color: Colors.blueAccent,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _navigateToSignUpScreen(context),
            )
          ],
        ),
      ),
    );
  }

  Future _navigateToSignUpScreen(BuildContext context) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext c) => const SignUpScreen(),
      ),
      (route) => false,
    );
  }

  Widget _signInButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(getWidthDevice(context, 65), 40),
        ),
        onPressed: () => _signIn(
          context,
          email: _textEditingControllerEmail.text,
          password: _textEditingControllerPassword.text,
        ),
        child: const Text("Sign In"),
      ),
    );
  }

  void _signIn(
    BuildContext context, {
    required String email,
    required String password,
  }) {
    UserRepository.getInstance()
        .signIn(email: email, password: password, isRemember: _isRemember)
        .then((result) {
      switch (result) {
        case ResultSuccess():
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (builder) => const HomeScreen(),
            ),
            (route) => false,
          );
        case ResultError():
          final err = result.exception;
          switch (err) {
            case SignInException():
              setState(() {
                switch (err) {
                  case SignInInputEmailException():
                    _errorMessageEmail = err.value;
                    _focusNodeEmail.requestFocus();
                    break;
                  case SignInInputPasswordException():
                    _errorMessagePassword = err.value;
                    _focusNodePassword.requestFocus();
                    break;
                }
              });
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    parserExceptionToString(result.exception),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
              break;
          }
      }
    });
  }

  SizedBox _sizeBoxHeight20() => const SizedBox(height: 20);
}
