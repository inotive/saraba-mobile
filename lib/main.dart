import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Saraba Mobile', home: const LoginPage());
  }
}
