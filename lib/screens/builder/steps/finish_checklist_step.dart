import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/resume_provider.dart';
import '../../preview/live_preview_screen.dart';
import '../../ats/ats_checker_screen.dart';

class FinishChecklistStep extends StatelessWidget {
  const FinishChecklistStep({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final resume = provider.activeResume;
    final percent = (resume.completionPercentage * 100).toInt();

    final checks = [
      {
        'title': 'Personal Information',
        'isDone': resume.personalInfo.fullName.isNotEmpty &&
            resume.personalInfo.email.isNotEmpty,
        'step': 0,
      },
      {
        'title': 'Professional Summary',
        'isDone': resume.summary.trim().isNotEmpty,
        'step': 1,
      },
      {
        'title': 'Work Experience',
        'isDone': resume.experiences.isNotEmpty,
        'step': 2,
      },
      {
        'title': 'Education',
        'isDone': resume.educations.isNotEmpty,
        'step': 3,
      },
      {
        'title': 'Skills & Keywords',
        'isDone': resume.skills.isNotEmpty,
        'step': 4,
      },
      {
        'title': 'Projects',
        'isDone': resume.projects.isNotEmpty,
        'step': 5,
      },
      {
        'title': 'Certifications',
        'isDone': resume.certifications.isNotEmpty,
        'step': 6,
      },
      {
        'title': 'Languages',
        'isDone': resume.languages.isNotEmpty,
        'step': 7,
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Score Header Card
        AppCard(
          padding: const EdgeInsets.all(24),
          color: isDark
              ? const Color(0xFF1E293B)
              : AppColors.primaryContainer.withOpacity( 0.4),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity( 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                percent >= 80 ? 'Ready for Job Applications!' : 'Almost There!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your resume is $percent% complete. Check the items below to maximize recruiter interest.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Resume Completion Checklist',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Checklist Items
        ...checks.map((item) {
          final isDone = item['isDone'] as bool;
          final step = item['step'] as int;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              onTap: () => provider.setStep(step),
              child: Row(
                children: [
                  Icon(
                    isDone
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isDone ? AppColors.success : Colors.grey,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: isDone ? null : TextDecoration.none,
                      ),
                    ),
                  ),
                  Text(
                    isDone ? 'Completed' : 'Add Info',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDone
                          ? AppColors.success
                          : (isDark
                              ? AppColors.primaryLight
                              : AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),

        // Review Button
        CustomButton(
          text: 'Review Resume',
          icon: Icons.visibility_rounded,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LivePreviewScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        // Check ATS Score Button
        CustomButton(
          text: 'Run ATS Compatibility Scan',
          variant: ButtonVariant.outline,
          icon: Icons.fact_check_rounded,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AtsCheckerScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
