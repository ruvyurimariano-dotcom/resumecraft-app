import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/education_model.dart';
import '../../../providers/resume_provider.dart';

class EducationStep extends StatefulWidget {
  const EducationStep({super.key});

  @override
  State<EducationStep> createState() => _EducationStepState();
}

class _EducationStepState extends State<EducationStep> {
  int? _expandedIndex = 0;

  void _addNewEducation() {
    final provider = context.read<ResumeProvider>();
    final newEdu = Education(
      degree: '',
      institution: '',
      location: '',
      startDate: DateTime(2018, 9),
      graduationDate: DateTime(2022, 5),
      gpa: '',
      description: '',
    );
    provider.addEducation(newEdu);
    setState(() {
      _expandedIndex = provider.activeResume.educations.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final educations = provider.activeResume.educations;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        SectionHeader(
          title: 'Education',
          subtitle: 'Include degrees, colleges, certifications, and honors.',
          actionText: '+ Add Degree',
          onAction: _addNewEducation,
        ),
        const SizedBox(height: 12),

        if (educations.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.school_outlined,
                    size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'No education entries added',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add your degree, university, or high school qualifications.',
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
                  text: '+ Add Education',
                  width: 200,
                  height: 44,
                  onPressed: _addNewEducation,
                ),
              ],
            ),
          )
        else
          ...List.generate(educations.length, (index) {
            final edu = educations[index];
            final isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                      title: Text(
                        edu.degree.isNotEmpty ? edu.degree : 'Degree / Program',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        edu.institution.isNotEmpty
                            ? edu.institution
                            : 'Add university or school',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      trailing: IconButton(
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
                    ),

                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Degree / Major',
                              hintText: 'e.g. B.S. in Computer Science',
                              initialValue: edu.degree,
                              isRequired: true,
                              onChanged: (val) => provider.updateEducation(
                                  index, edu.copyWith(degree: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Institution / University',
                              hintText: 'e.g. UC Berkeley',
                              initialValue: edu.institution,
                              isRequired: true,
                              onChanged: (val) => provider.updateEducation(
                                  index, edu.copyWith(institution: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Location',
                              hintText: 'e.g. Berkeley, CA',
                              initialValue: edu.location,
                              onChanged: (val) => provider.updateEducation(
                                  index, edu.copyWith(location: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'GPA or Honors (Optional)',
                              hintText: 'e.g. 3.85 / 4.0 or First Class Honors',
                              initialValue: edu.gpa,
                              onChanged: (val) => provider.updateEducation(
                                  index, edu.copyWith(gpa: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Description / Relevant Coursework',
                              hintText: 'e.g. Dean\'s Honor List, Data Structures, Mobile Systems...',
                              initialValue: edu.description,
                              maxLines: 2,
                              onChanged: (val) => provider.updateEducation(
                                  index, edu.copyWith(description: val)),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.delete_outline,
                                    size: 16, color: AppColors.error),
                                label: const Text('Remove Education',
                                    style: TextStyle(color: AppColors.error)),
                                onPressed: () =>
                                    provider.removeEducation(index),
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
          text: '+ Add Another Degree',
          variant: ButtonVariant.outline,
          onPressed: _addNewEducation,
        ),
      ],
    );
  }
}
