import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import 'template_picker_screen.dart';

class ResumeTypeOption {
  final String title;
  final String description;
  final IconData icon;

  const ResumeTypeOption({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class ResumeTypeSelectorScreen extends StatefulWidget {
  const ResumeTypeSelectorScreen({super.key});

  @override
  State<ResumeTypeSelectorScreen> createState() =>
      _ResumeTypeSelectorScreenState();
}

class _ResumeTypeSelectorScreenState extends State<ResumeTypeSelectorScreen> {
  String _selectedType = AppStrings.typeProfessional;

  final List<ResumeTypeOption> _options = const [
    ResumeTypeOption(
      title: AppStrings.typeProfessional,
      description: 'Best for experienced professionals with 2+ years of industry background.',
      icon: Icons.business_center_rounded,
    ),
    ResumeTypeOption(
      title: AppStrings.typeStudent,
      description: 'Tailored for current students and interns focusing on coursework & campus roles.',
      icon: Icons.school_rounded,
    ),
    ResumeTypeOption(
      title: AppStrings.typeEntryLevel,
      description: 'Ideal for recent graduates showcasing practical projects, skills, and certifications.',
      icon: Icons.rocket_launch_rounded,
    ),
    ResumeTypeOption(
      title: AppStrings.typeCreative,
      description: 'Compelling visual layout for designers, creative directors, and content creators.',
      icon: Icons.palette_rounded,
    ),
    ResumeTypeOption(
      title: AppStrings.typeAcademic,
      description: 'Comprehensive curriculum vitae for scholars, researchers, and university faculty.',
      icon: Icons.menu_book_rounded,
    ),
    ResumeTypeOption(
      title: AppStrings.typeExecutive,
      description: 'High-impact presentation for VPs, directors, and C-level executive leaders.',
      icon: Icons.military_tech_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Resume'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Step 1 of 2',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose Resume Type',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select the career format that best fits your experience level and goals.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ..._options.map((opt) {
                    final isSelected = _selectedType == opt.title;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        border: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.outlineDark
                                  : AppColors.outlineLight),
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? (isDark
                                ? const Color(0xFF1E293B)
                                : AppColors.primaryContainer.withValues(alpha: 0.35))
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedType = opt.title;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                opt.icon,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.primaryLight
                                        : AppColors.primary),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    opt.title,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.primaryLight
                                              : AppColors.primary)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    opt.description,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMutedLight),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                  ),
                ),
              ),
              child: CustomButton(
                text: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TemplatePickerScreen(resumeType: _selectedType),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
