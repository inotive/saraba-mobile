import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:saraba_mobile/ui/login/bloc/login_bloc.dart';
import 'package:saraba_mobile/ui/login/bloc/login_event.dart';
import 'package:saraba_mobile/ui/login/bloc/login_state.dart';
import 'package:saraba_mobile/ui/login/login_form.dart';
import 'package:saraba_mobile/ui/common/home_page.dart';
import '../common/bottomsheet_navigation/bloc/navigation_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(AuthService()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
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

          if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LoginForm(
              onLogin: (email, password) {
                context.read<LoginBloc>().add(LoginSubmitted(email, password));
              },
            ),
          ),
        ),
      ),
    );
  }
}
