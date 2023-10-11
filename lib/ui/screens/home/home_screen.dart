import 'package:flutter/material.dart';
import 'package:submission/data/models/user.dart';
import 'package:submission/data/repository/user_repository.dart';
import 'package:submission/ui/screens/started/started_screen.dart';
import 'package:submission/ui/widgets/info_user_widget.dart';
import 'package:submission/ui/widgets/splash_progress_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoad = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: UserRepository.getInstance().getCurrentUser(),
      builder: (context, snapshot) {
        User? user = snapshot.data;
        Widget content;
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            if (_isLoad && user != null) {
              content = InfoUserWidget(
                user: user,
                isLoading: true,
              );
            } else {
              content = const SplashProgressWidget();
            }
          case ConnectionState.done:
            _isLoad = true;
            if (user != null) {
              content = InfoUserWidget(
                user: user,
                isLoading: false,
                onChange: () => setState(() {}),
              );
            } else {
              Future.microtask(() {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const StartedScreen(),
                  ),
                  (route) => false,
                );
              });
              content = const SplashProgressWidget();
            }
        }
        return Scaffold(
          body: SafeArea(
            child: content,
          ),
        );
      },
    );
  }
}
