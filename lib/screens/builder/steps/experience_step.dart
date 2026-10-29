import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/experience_model.dart';
import '../../../providers/resume_provider.dart';
import '../../../services/ai_service.dart';

class ExperienceStep extends StatefulWidget {
  const ExperienceStep({super.key});

  @override
  State<ExperienceStep> createState() => _ExperienceStepState();
}

class _ExperienceStepState extends State<ExperienceStep> {
  int? _expandedIndex = 0;

  void _addNewExperience() {
    final provider = context.read<ResumeProvider>();
    final newExp = WorkExperience(
      jobTitle: '',
      company: '',
      location: '',
      startDate: DateTime.now().subtract(const Duration(days: 365)),
      isCurrentlyWorking: true,
      description: '',
      achievements: [],
    );
    provider.addExperience(newExp);
    setState(() {
      _expandedIndex = provider.activeResume.experiences.length - 1;
    });
  }

  Future<void> _generateAiDescription(int index, WorkExperience exp) async {
    final provider = context.read<ResumeProvider>();
    final bullets = await AiService.generateAchievements(
      jobTitle: exp.jobTitle,
      company: exp.company,
    );
    final updated = exp.copyWith(
      achievements: [...exp.achievements, ...bullets],
    );
    provider.updateExperience(index, updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final experiences = provider.activeResume.experiences;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        SectionHeader(
          title: 'Work Experience',
          subtitle: 'Highlight your roles, milestones, and measurable results.',
          actionText: '+ Add Job',
          onAction: _addNewExperience,
        ),
        const SizedBox(height: 12),

        if (experiences.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.work_outline_rounded,
                    size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'No experience added yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add your current or past job roles to showcase your career journey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: '+ Add Experience',
                  width: 200,
                  height: 44,
                  onPressed: _addNewExperience,
                ),
              ],
            ),
          )
        else
          ...List.generate(experiences.length, (index) {
            final exp = experiences[index];
            final isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Card Header (Expandable toggle)
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.business_center_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                      title: Text(
                        exp.jobTitle.isNotEmpty
                            ? exp.jobTitle
                            : 'Untitled Role',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        exp.company.isNotEmpty
                            ? '${exp.company} • ${DateFormatter.formatRange(exp.startDate, exp.endDate, isCurrent: exp.isCurrentlyWorking)}'
                            : 'Add company details',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (index > 0)
                            IconButton(
                              icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                              onPressed: () =>
                                  provider.reorderExperience(index, index - 1),
                            ),
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                            ),
                            onPressed: () {
                              setState(() {
                                _expandedIndex = isExpanded ? null : index;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Expanded Form
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Job Title',
                              hintText: 'e.g. Senior Mobile Engineer',
                              initialValue: exp.jobTitle,
                              isRequired: true,
                              onChanged: (val) => provider.updateExperience(
                                  index, exp.copyWith(jobTitle: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Company Name',
                              hintText: 'e.g. TechFlow Systems',
                              initialValue: exp.company,
                              isRequired: true,
                              onChanged: (val) => provider.updateExperience(
                                  index, exp.copyWith(company: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Location',
                              hintText: 'e.g. San Francisco, CA / Remote',
                              initialValue: exp.location,
                              onChanged: (val) => provider.updateExperience(
                                  index, exp.copyWith(location: val)),
                            ),
                            const SizedBox(height: 12),

                            // Currently Working Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: exp.isCurrentlyWorking,
                                  onChanged: (val) {
                                    provider.updateExperience(
                                      index,
                                      exp.copyWith(
                                        isCurrentlyWorking: val ?? false,
                                        endDate: (val ?? false) ? null : DateTime.now(),
                                      ),
                                    );
                                  },
                                ),
                                const Text('I currently work here'),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Description & AI Assistant
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Role Responsibilities',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.auto_awesome, size: 14),
                                  label: const Text('Generate Achievements',
                                      style: TextStyle(fontSize: 12)),
                                  onPressed: () =>
                                      _generateAiDescription(index, exp),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              initialValue: exp.description,
                              maxLines: 3,
                              onChanged: (val) => provider.updateExperience(
                                  index, exp.copyWith(description: val)),
                              decoration: const InputDecoration(
                                hintText:
                                    'Summarize your primary duties and leadership contributions...',
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Achievements Bullets
                            const Text(
                              'Key Achievements (Quantified Results)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            ...List.generate(exp.achievements.length, (achIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle,
                                        size: 6, color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        exp.achievements[achIndex],
                                        style: const TextStyle(fontSize: 12.5),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline,
                                          size: 16, color: Colors.grey),
                                      onPressed: () {
                                        final list =
                                            List<String>.from(exp.achievements)
                                              ..removeAt(achIndex);
                                        provider.updateExperience(
                                            index, exp.copyWith(achievements: list));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),

                            // Delete Card Action
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.delete_outline,
                                    size: 16, color: AppColors.error),
                                label: const Text('Remove Role',
                                    style: TextStyle(color: AppColors.error)),
                                onPressed: () =>
                                    provider.removeExperience(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),

        const SizedBox(height: 16),
        CustomButton(
          text: '+ Add Another Experience',
          variant: ButtonVariant.outline,
          onPressed: _addNewExperience,
        ),
      ],
    );
  }
}
