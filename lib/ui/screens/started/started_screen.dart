import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:submission/ui/screens/sign/in/sign_in_screen.dart';
import 'package:submission/ui/screens/sign/up/sign_up_screen.dart';
import 'package:submission/ui/utils/utils.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: _StartedScreenBody(),
      ),
      onWillPop: () {
        SystemNavigator.pop(animated: true);
        return Future.value(true);
      },
    );
  }
}

class _StartedScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlue, Colors.white],
        ),
      ),
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _icon(
                  EdgeInsets.only(
                    top: getHeightDevice(context, 15),
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleText(),
                          const SizedBox(height: 8),
                          _titleSubText(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    _createAccountButton(context),
                    _alreadyAccountText(context),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleText() => const Text(
        'Let\'s Get Started',
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _titleSubText() => const Text(
        "Submission belajar membuat aplikasi flutter untuk pemula",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _alreadyAccountText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Already have an account?",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: " Login",
              style: const TextStyle(color: Colors.blueAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (builder) => const SignInScreen(),
                      ),
                      (route) => false,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(getWidthDevice(context, 75), 40),
        ),
        child: const Text(
          "CREATE ACCOUNT",
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (builder) => const SignUpScreen(),
            ),
            (route) => false,
          );
        },
      ),
    );
  }

  Widget _icon(EdgeInsets margin) {
    return Center(
      child: Container(
        margin: margin,
        child: Image.asset(
          "assets/images/icon.png",
          width: 200,
          height: 150,
        ),
      ),
    );
  }
}
