import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/repository.dart';
import 'package:submission_bmafup/data/user.dart';
import 'package:submission_bmafup/screen/home/home_screen.dart';
import 'package:submission_bmafup/screen/started/started_screen.dart';

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    User? currentUser = await SignRepository.getInstance().getCurrentUser();

    Widget widget;

    if (currentUser != null) {
      widget = HomeScreen(currentUser);
    } else {
      widget = const StartedScreen();
    }

    widgetsBinding
      ..scheduleAttachRootWidget(widget)
      ..scheduleWarmUpFrame();
  } catch (err) {
    log("$err");
    exit(1);
  }
}
