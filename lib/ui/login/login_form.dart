import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saraba_mobile/ui/login/bloc/login_bloc.dart';
import 'package:saraba_mobile/ui/login/bloc/login_state.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password)? onLogin;

  const LoginForm({super.key, this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const Color _brandOrange = Color(0xFFFF9955);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      widget.onLogin?.call(emailController.text, passwordController.text);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FormLabel(
              label: 'Email',
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Ketik Disini'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email wajib diisi";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 14),
            _FormLabel(
              label: 'Kata Sandi',
              child: TextFormField(
                controller: passwordController,
                obscureText: isObscure,
                decoration: _inputDecoration('••••••••••••••').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xFF98A2B3),
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password wajib diisi";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Jika ada masalah segera hubungi '),
                    TextSpan(
                      text: 'Admin',
                      style: TextStyle(
                        color: Color(0xFF3A4A64),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: Color(0xFF98A2B3),
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 14),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                final isLoading = state is LoginLoading;

                return SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _brandOrange,
                      disabledBackgroundColor: _brandOrange.withValues(
                        alpha: 0.55,
                      ),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.4,
                            ),
                          )
                        : const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    const borderColor = Color(0xFFD9DEE7);

    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFFB4BBC7), fontSize: 14),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _brandOrange, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormLabel({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
