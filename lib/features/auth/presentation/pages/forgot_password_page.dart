import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 50,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          const Text(
            'Lupa Password?',
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Masukkan email Anda dan kami akan mengirimkan link untuk reset password',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          // Email Field
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Masukkan email Anda',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: Validators.email,
          ),

          const SizedBox(height: 24),

          // Submit Button
          PrimaryButton(
            onPressed: _handleSubmit,
            isLoading: _isLoading,
            text: 'Kirim Link Reset',
          ),

          const SizedBox(height: 16),

          // Back to login
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Kembali ke Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),

        // Success Icon
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read,
              size: 50,
              color: AppColors.success,
            ),
          ),
        ),

        const SizedBox(height: 32),

        const Text(
          'Email Terkirim!',
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Text(
          'Kami telah mengirimkan link reset password ke email Anda. Silakan cek inbox atau folder spam.',
          style: AppTextStyles.body1.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        PrimaryButton(
          onPressed: () => context.pop(),
          text: 'Kembali ke Login',
        ),

        const SizedBox(height: 16),

        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: const Text('Kirim Ulang Email'),
        ),
      ],
    );
  }
}
