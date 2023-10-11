import 'package:flutter/material.dart';
import 'package:submission/data/repository/user_repository.dart';
import 'package:submission/data/results.dart';
import 'package:submission/ui/screens/sign/in/alert_dialog_forget_password_code.dart';
import 'package:submission/ui/utils/utils.dart';

class AlertDialogForgetPassword extends StatefulWidget {
  const AlertDialogForgetPassword({super.key});

  @override
  State<AlertDialogForgetPassword> createState() =>
      _AlertDialogForgetPasswordState();
}

class _AlertDialogForgetPasswordState extends State<AlertDialogForgetPassword> {
  final TextEditingController textEditingController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.addListener(() {
      if (errorMessage != null) {
        setState.call(() {
          errorMessage = null;
        });
      }
    });
    return AlertDialog(
      title: const Text("Forget Password"),
      content: TextField(
        controller: textEditingController,
        focusNode: FocusNode()..requestFocus(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          errorText: errorMessage,
          border: const OutlineInputBorder(),
          hintText: "Enter your email",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            UserRepository.getInstance()
                .forgetPassword(textEditingController.text)
                .then((result) {
              switch (result) {
                case ResultSuccess<String>():
                  Navigator.pop(context);
                  _showDialogCodeForgetPassword(result.value);
                case ResultError():
                  setState.call(() {
                    errorMessage = parserExceptionToString(result.exception);
                  });
              }
            });
          },
          child: const Text("Get code"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  Future<dynamic> _showDialogCodeForgetPassword(String password) {
    return showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (context) => AlertDialogForgetPasswordCode(password: password),
    );
  }
}
