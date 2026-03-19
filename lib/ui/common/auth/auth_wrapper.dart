import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_bloc.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_event.dart';
import 'package:saraba_mobile/ui/common/auth/bloc/auth_state.dart';
import 'package:saraba_mobile/ui/common/bottomsheet_navigation/bloc/navigation_bloc.dart';
import 'package:saraba_mobile/ui/common/home_page.dart';
import 'package:saraba_mobile/ui/login/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(CheckAuthStatus());

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthAuthenticated) {
            return BlocProvider(
              create: (_) => NavigationBloc(),
              child: const HomePage(),
            );
          }

          return const LoginPage();
        },
      ),
    );
  }
}
