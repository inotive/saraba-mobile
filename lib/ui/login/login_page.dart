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
  final String? bannerTitle;
  final String? bannerMessage;
  final StatusBannerType? bannerType;

  const LoginPage({
    super.key,
    this.bannerTitle,
    this.bannerMessage,
    this.bannerType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(AuthService()),
      child: _LoginView(
        bannerTitle: bannerTitle,
        bannerMessage: bannerMessage,
        bannerType: bannerType,
      ),
    );
  }
}

class _LoginView extends StatefulWidget {
  final String? bannerTitle;
  final String? bannerMessage;
  final StatusBannerType? bannerType;

  const _LoginView({this.bannerTitle, this.bannerMessage, this.bannerType});

  static const Color _brandBlue = Color(0xFF3B6197);

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  @override
  void initState() {
    super.initState();
    if (widget.bannerTitle != null &&
        widget.bannerMessage != null &&
        widget.bannerType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        StatusBanner.show(
          context,
          title: widget.bannerTitle!,
          message: widget.bannerMessage!,
          type: widget.bannerType!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: keyboardInset),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: _buildHero(
                                  isKeyboardOpen: isKeyboardOpen,
                                ),
                              ),
                              const Spacer(),
                              LoginForm(
                                onLogin: (email, password) {
                                  context.read<LoginBloc>().add(
                                    LoginSubmitted(email, password),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero({required bool isKeyboardOpen}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: isKeyboardOpen ? 40 : 150),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: isKeyboardOpen ? 56 : 80,
            height: isKeyboardOpen ? 56 : 80,
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
            padding: EdgeInsets.all(isKeyboardOpen ? 10 : 16),
            child: Image.asset('assets/images/saraba_logo.png'),
          ),
          SizedBox(height: isKeyboardOpen ? 12 : 22),
          Text(
            'Selamat Datang',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isKeyboardOpen ? 20 : 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isKeyboardOpen ? 0.0 : 1.0,
            child: Column(
              children: [
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
          SizedBox(height: isKeyboardOpen ? 0 : 120),
        ],
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
