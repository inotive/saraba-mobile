import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:saraba_mobile/repository/model/user_model.dart';
import 'package:saraba_mobile/ui/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<User>("userBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Saraba Mobile', home: const LoginPage());
  }
}
