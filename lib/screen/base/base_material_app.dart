import 'package:flutter/material.dart';

class BaseMaterialApp extends StatelessWidget {
  final Widget? home;

  const BaseMaterialApp({
    Key? key,
    this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: key,
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
