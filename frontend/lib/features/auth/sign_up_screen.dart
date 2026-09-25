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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _error;
  final Map<String, String> _fieldErrors = {};

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
      _fieldErrors.clear();
    });

    try {
      await AuthService.register(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phone: '+234${_phone.text.trim()}',
        password: _password.text,
      );
      if (mounted) context.go('/dashboard');
    } on ApiException catch (e) {
      setState(() {
        _error = e.fieldErrors.isEmpty ? e.message : null;
        _fieldErrors.addAll(e.fieldErrors);
      });
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
              'Create an account',
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
                        'Sign up for Myafrimall and gain unlimited access to shipping to over '
                        '300 countries from Nigeria. Do you already have an account? ',
                  ),
                  TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: (TapGestureRecognizer()
                      ..onTap = () => context.go('/login')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            isDesktop
                ? Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'First name',
                          hint: 'John',
                          controller: _firstName,
                          errorText: _fieldErrors['firstName'],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          label: 'Last name',
                          hint: 'Doe',
                          controller: _lastName,
                          errorText: _fieldErrors['lastName'],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      AppTextField(
                        label: 'First name',
                        hint: 'John',
                        controller: _firstName,
                        errorText: _fieldErrors['firstName'],
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Last name',
                        hint: 'Doe',
                        controller: _lastName,
                        errorText: _fieldErrors['lastName'],
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Email',
              hint: 'user@example.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              errorText: _fieldErrors['email'],
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Phone Number',
              hint: '8012345678',
              controller: _phone,
              keyboardType: TextInputType.phone,
              errorText: _fieldErrors['phone'],
              prefix: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    '+234',
                    style: TextStyle(fontSize: 16, color: AppColors.neutral400),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Password',
              hint: 'Enter Password',
              controller: _password,
              obscureText: _obscure,
              errorText: _fieldErrors['password'],
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
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
              label: 'Create account',
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
          Expanded(
            child: AuthSidePanel(
              heading:
                  'Seamlessly Delivering to Over 300 Countries from Nigeria!',
              body:
                  'Access global markets with our quick shipping from Nigeria! '
                  'Fast delivery and easy customs to 300+ countries.',
            ),
          ),
        ],
      ),
    );
  }
}