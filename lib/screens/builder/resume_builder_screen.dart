import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/step_progress_bar.dart';
import '../../providers/resume_provider.dart';
import 'steps/personal_info_step.dart';
import 'steps/summary_step.dart';
import 'steps/experience_step.dart';
import 'steps/education_step.dart';
import 'steps/skills_step.dart';
import 'steps/projects_step.dart';
import 'steps/certifications_step.dart';
import 'steps/languages_step.dart';
import 'steps/references_step.dart';
import 'steps/finish_checklist_step.dart';
import '../preview/live_preview_screen.dart';
import '../ai/ai_assistant_bottom_sheet.dart';

class ResumeBuilderScreen extends StatefulWidget {
  const ResumeBuilderScreen({super.key});

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  final List<Widget> _steps = const [
    PersonalInfoStep(),
    SummaryStep(),
    ExperienceStep(),
    EducationStep(),
    SkillsStep(),
    ProjectsStep(),
    CertificationsStep(),
    LanguagesStep(),
    ReferencesStep(),
    FinishChecklistStep(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final resume = provider.activeResume;
    final currentStep = provider.currentStep;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        provider.forceSave();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            resume.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            // AI Assistant Sparkle Button
            IconButton(
              icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
              tooltip: 'AI Assistant',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const AiAssistantBottomSheet(),
                );
              },
            ),
            // Live Preview Button
            TextButton.icon(
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Preview'),
              onPressed: () {
                provider.forceSave();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LivePreviewScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top Progress Header
              StepProgressBar(
                currentStep: currentStep,
                totalSteps: AppStrings.builderSteps.length,
                stepName: AppStrings.builderSteps[currentStep],
                completionPercentage: resume.completionPercentage,
                saveStatus: provider.saveStatus,
                isSaving: provider.isSaving,
              ),

              // Step Horizontal Mini Navigator
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.outlineDark
                          : AppColors.outlineLight,
                    ),
                  ),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: AppStrings.builderSteps.length,
                  itemBuilder: (context, index) {
                    final isCurrent = index == currentStep;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          selected: isCurrent,
                          label: Text('${index + 1}. ${AppStrings.builderSteps[index]}'),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                            color: isCurrent
                                ? (isDark ? AppColors.primaryLight : AppColors.primary)
                                : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                          ),
                          selectedColor: isDark
                              ? const Color(0xFF1E3A8A)
                              : AppColors.primaryContainer,
                          onSelected: (val) {
                            if (val) provider.setStep(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Active Step Form View
              Expanded(
                child: _steps[currentStep],
              ),

              // Bottom Navigation Bar (Back & Next Buttons)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.outlineDark
                          : AppColors.outlineLight,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Previous'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: () => provider.previousStep(),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: currentStep == 0 ? 2 : 1,
                      child: FilledButton.icon(
                        icon: Icon(
                          currentStep == 9
                              ? Icons.visibility_rounded
                              : Icons.arrow_forward_rounded,
                          size: 18,
                        ),
                        label: Text(
                          currentStep == 9 ? 'Review Resume' : 'Save & Continue',
                        ),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          if (currentStep < 9) {
                            provider.nextStep();
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LivePreviewScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
