import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isAnnual = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final isPro = auth.currentUser?.isPro ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ResumeCraft Pro'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pro Badge & Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      'PREMIUM MEMBERSHIP',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Supercharge Your Job Hunt',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock unlimited AI generation, executive ATS templates, and job posting matching.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Billing Cycle Toggle (Monthly vs Annual with Save 35% badge)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnnual = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isAnnual
                                ? (isDark ? AppColors.surfaceDark : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: !_isAnnual
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity( 0.05),
                                      blurRadius: 4,
                                    )
                                  ]
                                : null,
                          ),
                          child: const Text(
                            'Monthly',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAnnual = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isAnnual
                                ? (isDark ? AppColors.surfaceDark : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _isAnnual
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity( 0.05),
                                      blurRadius: 4,
                                    )
                                  ]
                                : null,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Annual',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'SAVE 35%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Price Card
              AppCard(
                padding: const EdgeInsets.all(20),
                color: isDark
                    ? const Color(0xFF1E293B)
                    : AppColors.primaryContainer.withOpacity( 0.35),
                border: BorderSide(
                  color: AppColors.primary.withOpacity( 0.4),
                  width: 1.5,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _isAnnual ? '\$3.33' : '\$6.99',
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                            ' / month',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isAnnual
                          ? 'Billed annually at \$39.99/year. Cancel anytime.'
                          : 'Billed monthly. Cancel anytime.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feature Comparison
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What is Included in Pro',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              _featureRow('All 7+ Premium & Executive Templates', isPro: true),
              _featureRow('Unlimited AI Resume Assistant Prompts', isPro: true),
              _featureRow('Deep ATS Parser & Keyword Scanner', isPro: true),
              _featureRow('Job Description Matching & Gap Analysis', isPro: true),
              _featureRow('Vectorized High-Res PDF Export (A4 & Letter)', isPro: true),
              _featureRow('Remove Watermark & Custom Palettes', isPro: true),
              _featureRow('Unlimited Saved Resumes & Cloud Backup', isPro: true),

              const SizedBox(height: 28),

              if (isPro)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_rounded, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(
                        'You are on the Pro Plan!',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                CustomButton(
                  text: _isAnnual
                      ? 'Upgrade to Pro (\$39.99/yr)'
                      : 'Upgrade to Pro (\$6.99/mo)',
                  icon: Icons.star_rounded,
                  onPressed: () {
                    auth.upgradeToPro();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Welcome to ResumeCraft Pro! All features unlocked.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureRow(String feature, {required bool isPro}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
