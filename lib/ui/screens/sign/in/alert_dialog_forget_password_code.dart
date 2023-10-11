import 'package:flutter/material.dart';
import 'package:submission/ui/utils/utils.dart';

class AlertDialogForgetPasswordCode extends StatelessWidget {
  final String password;

  const AlertDialogForgetPasswordCode({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Password",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(password),
          const SizedBox(height: 16),
          SizedBox(
            width: getWidthDevice(context, 45),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}
