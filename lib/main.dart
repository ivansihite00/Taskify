import 'package:flutter/material.dart';
import 'package:tubes_pm/screen/splash.dart';
import 'package:tubes_pm/screen/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}