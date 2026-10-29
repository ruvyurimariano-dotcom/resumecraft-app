import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentStep = 0; // 0: Email, 1: OTP, 2: New Password, 3: Success
  final _emailController = TextEditingController(text: 'alex.morgan@example.com');
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final emailError = Validators.email(_emailController.text);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _isLoading = false;
      _currentStep = 1;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 4 to 6 digit code.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _isLoading = false;
      _currentStep = 2;
    });
  }

  Future<void> _resetPassword() async {
    final pError = Validators.password(_passwordController.text);
    if (pError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pError), backgroundColor: AppColors.error),
      );
      return;
    }

    final cError = Validators.confirmPassword(
        _confirmPasswordController.text, _passwordController.text);
    if (cError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cError), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _isLoading = false;
      _currentStep = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: switch (_currentStep) {
            0 => _buildEmailStep(isDark),
            1 => _buildOtpStep(isDark),
            2 => _buildNewPasswordStep(isDark),
            3 => _buildSuccessStep(isDark),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }

  Widget _buildEmailStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forgot Password?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the email address associated with your account, and we will send you a verification code.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 28),
        CustomTextField(
          label: 'Email Address',
          hintText: 'alex.morgan@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, size: 20),
          isRequired: true,
        ),
        const SizedBox(height: 28),
        CustomButton(
          text: 'Send Verification Code',
          isLoading: _isLoading,
          onPressed: _sendOtp,
        ),
      ],
    );
  }

  Widget _buildOtpStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter Verification Code',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'We sent a 6-digit verification code to ${_emailController.text}. Enter it below to verify your account.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 28),
        CustomTextField(
          label: 'Verification Code',
          hintText: 'e.g. 583921',
          controller: _otpController,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.pin_outlined, size: 20),
          isRequired: true,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _sendOtp,
              child: const Text('Resend Code'),
            ),
            TextButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: const Text('Change Email'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Verify Code',
          isLoading: _isLoading,
          onPressed: _verifyOtp,
        ),
      ],
    );
  }

  Widget _buildNewPasswordStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create New Password',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Your new password must be different from previous passwords and at least 6 characters.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 28),
        CustomTextField(
          label: 'New Password',
          hintText: 'Enter new password',
          controller: _passwordController,
          isPassword: true,
          isRequired: true,
          prefixIcon: const Icon(Icons.lock_outline, size: 20),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Confirm New Password',
          hintText: 'Confirm new password',
          controller: _confirmPasswordController,
          isPassword: true,
          isRequired: true,
          prefixIcon: const Icon(Icons.lock_reset_outlined, size: 20),
        ),
        const SizedBox(height: 28),
        CustomButton(
          text: 'Update Password',
          isLoading: _isLoading,
          onPressed: _resetPassword,
        ),
      ],
    );
  }

  Widget _buildSuccessStep(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.successContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Password Changed!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your password has been successfully reset. You can now log in using your new credentials.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 36),
          CustomButton(
            text: 'Return to Login',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
