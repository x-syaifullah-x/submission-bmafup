import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashProgressWidget extends StatelessWidget {
  const SplashProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlue, Colors.white],
        ),
      ),
      child: const CupertinoActivityIndicator(
        animating: true,
        radius: 16,
      ),
    );
  }
}
