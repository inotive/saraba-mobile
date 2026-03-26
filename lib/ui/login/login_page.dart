import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/services/auth_service.dart';
import 'package:saraba_mobile/ui/login/bloc/login_bloc.dart';
import 'package:saraba_mobile/ui/login/bloc/login_event.dart';
import 'package:saraba_mobile/ui/login/bloc/login_state.dart';
import 'package:saraba_mobile/ui/login/login_form.dart';
import 'package:saraba_mobile/ui/common/home_page.dart';
import 'package:saraba_mobile/ui/common/widgets/status_banner.dart';
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

  static const Color _brandBlue = Color(0xFF3B6197);

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
                  child: const HomePage(
                    successBannerTitle: 'Log In Berhasil',
                    successBannerMessage: 'Kamu Berhasil Masuk ke Akun Kamu',
                  ),
                ),
              ),
            );
          }

          if (state is LoginFailure) {
            StatusBanner.show(
              context,
              title: 'Log In Tidak Berhasil',
              message: state.message,
              type: StatusBannerType.error,
            );
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFBE3D2), Color(0xFFF4F6FB)],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: _LoginBackground()),
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Image.asset('assets/images/saraba_logo.png'),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Selamat Datang',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          'di Aplikasi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.88),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'SARABA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LoginForm(
                    onLogin: (email, password) {
                      context.read<LoginBloc>().add(
                        LoginSubmitted(email, password),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: _LoginView._brandBlue)),
        Positioned.fill(
          child: Image.asset(
            'assets/images/login_frame.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ],
    );
  }
}
