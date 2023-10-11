import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:submission/data/models/update_input.dart';
import 'package:submission/data/models/user.dart';
import 'package:submission/data/repository/user_repository.dart';
import 'package:submission/data/results.dart';
import 'package:submission/ui/screens/sign/in/sign_in_screen.dart';
import 'package:submission/ui/utils/utils.dart';

class InfoUserWidget extends StatelessWidget {
  final User _user;
  final bool _isLoading;
  final Function? _onChange;

  const InfoUserWidget({
    super.key,
    required User user,
    bool isLoading = false,
    Function? onChange,
  })  : _user = user,
        _isLoading = isLoading,
        _onChange = onChange;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 14,
                  top: 28,
                  right: 14,
                  bottom: 38,
                ),
                child: const Text(
                  "User Info",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              _buildFieldInfo(
                context,
                FieldId.name,
                _user.name,
              ),
              _buildFieldInfo(
                context,
                FieldId.email,
                _user.email,
              ),
              _buildFieldInfo(
                context,
                FieldId.phoneNumber,
                _user.phoneNumber,
              ),
              _buildFieldInfo(
                context,
                FieldId.password,
                "******",
              ),
              if (_isLoading)
                const CupertinoActivityIndicator(animating: true)
              else
                Container(),
              Expanded(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(getWidthDevice(context, 75), 40),
                    ),
                    onPressed: () => {
                      UserRepository.getInstance().signOut().then((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (builder) => const SignInScreen(),
                          ),
                          (route) => false,
                        );
                      }),
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFieldInfo(BuildContext context, FieldId field, String value) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(left: 12, top: 2, right: 12, bottom: 2),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                onPressed: () {
                  _update(field, context);
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    // minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                child: const Text("Change"),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _update(FieldId id, BuildContext context) {
    switch (id) {
      case FieldId.name:
        _showDialogUpdate(
          context,
          "Change Name",
          "Please input your name",
          TextInputType.text,
          (String input) => UpdateTypeName(input),
        );
        break;
      case FieldId.email:
        _showDialogUpdate(
          context,
          "Change Email",
          "Please input your email",
          TextInputType.emailAddress,
          (String input) => UpdateTypeEmail(input),
        );
        break;
      case FieldId.phoneNumber:
        _showDialogUpdate(
          context,
          "Change Phone Number",
          "Please input your phone number",
          TextInputType.phone,
          (String input) => UpdateTypePhoneNumber(input),
        );
        break;
      case FieldId.password:
        _showDialogUpdate(
          context,
          "Change Password",
          "Please input your password",
          TextInputType.visiblePassword,
          (String input) => UpdateTypePassword(input),
        );
        break;
    }
  }

  void _showDialogUpdate(
    BuildContext context,
    String title,
    String hint,
    TextInputType keyboardType,
    OnUpdateClicked onUpdate,
  ) {
    final bool isTextPassword = (keyboardType == TextInputType.visiblePassword);
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isObscureTextPassword = isTextPassword;
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            textEditingController.addListener(() {
              if (errorText != null) {
                setState.call(() {
                  errorText = null;
                });
              }
            });
            return AlertDialog(
              title: Text(title),
              content: TextField(
                keyboardType: keyboardType,
                controller: textEditingController,
                focusNode: FocusNode()..requestFocus(),
                obscureText: isObscureTextPassword,
                decoration: InputDecoration(
                  errorText: errorText,
                  suffixIcon: isTextPassword
                      ? IconButton(
                          icon: Icon(
                            isObscureTextPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState.call(() {
                              isObscureTextPassword = !isObscureTextPassword;
                            });
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                  hintText: hint,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    UpdateInput type =
                        onUpdate.call(textEditingController.text);
                    UserRepository.getInstance().update(type).then((result) {
                      switch (result) {
                        case ResultSuccess():
                          Navigator.pop(context);
                          _onChange?.call();
                        case ResultError():
                          setState.call(() {
                            errorText =
                                parserExceptionToString(result.exception);
                          });
                      }
                    });
                  },
                  child: const Text("Change"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      textEditingController.clear();
    });
  }
}

enum FieldId {
  name("Name"),
  email("Email"),
  phoneNumber("Phone Number"),
  password("Password");

  final String value;

  const FieldId(this.value);
}

typedef OnUpdateClicked = UpdateInput Function(String input);
