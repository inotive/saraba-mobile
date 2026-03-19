import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/auth/login_form.dart';
import 'package:saraba_mobile/ui/common/home_page.dart';
import '../common/bottomsheet_navigation/bloc/navigation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LoginForm(
            onLogin: (email, password) {
              // TODO: call API here

              bool isSuccess = true;

              if (isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => NavigationBloc(),
                      child: const HomePage(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
