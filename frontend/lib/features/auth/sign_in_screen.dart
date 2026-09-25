import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_side_panel.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/api/api_client.dart';
import 'auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AuthService.login(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) context.go('/dashboard');
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final form = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 536),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign in to your account',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  height: 22 / 14,
                  color: AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(
                    text:
                        'Log in to Myafrimall to enjoy seamless shipping to over 300 '
                        'countries right from Nigeria. Don\'t have an account yet? ',
                  ),
                  TextSpan(
                    text: 'Sign Up',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: (TapGestureRecognizer()
                      ..onTap = () => context.go('/signup')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: 'Email',
              hint: 'user@example.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Password',
              hint: 'Enter Password',
              controller: _password,
              obscureText: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 28),
            if (_error != null) ...[
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            PrimaryButton(
              label: 'Login',
              onPressed: _submit,
              loading: _loading,
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  height: 22 / 14,
                  color: AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(
                    text: 'By clicking on create account you agree to our ',
                  ),
                  const TextSpan(
                    text: 'privacy policy',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  const TextSpan(
                    text: 'terms of use',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!isDesktop) {
      return Scaffold(
        backgroundColor: AppColors.authBg,
        body: SafeArea(child: form),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: AppColors.authBg,
              child: Center(child: form),
            ),
          ),
          const Expanded(
            child: AuthSidePanel(
              heading: 'Effortlessly Track Your Shipments from Nigeria!',
              body:
                  'Monitor your shipments from Nigeria! Enjoy swift delivery and '
                  'seamless customs processing.',
            ),
          ),
        ],
      ),
    );
  }
}