import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/reference_model.dart';
import '../../../providers/resume_provider.dart';

class ReferencesStep extends StatefulWidget {
  const ReferencesStep({super.key});

  @override
  State<ReferencesStep> createState() => _ReferencesStepState();
}

class _ReferencesStepState extends State<ReferencesStep> {
  int? _expandedIndex = 0;

  void _addNewReference() {
    final provider = context.read<ResumeProvider>();
    final newRef = Reference(
      name: '',
      jobTitle: '',
      company: '',
      email: '',
      phone: '',
    );
    provider.addReference(newRef);
    setState(() {
      _expandedIndex = provider.activeResume.references.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final references = provider.activeResume.references;
    final includeReferences = provider.activeResume.includeReferences;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const SectionHeader(
          title: 'Professional References',
          subtitle: 'Include contact information for past managers or mentors.',
        ),
        const SizedBox(height: 12),

        // Toggle: Do not include references
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Include References Section',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    includeReferences
                        ? 'References will be visible on your resume.'
                        : 'Displays "References available upon request".',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              Switch(
                value: includeReferences,
                onChanged: (val) => provider.toggleIncludeReferences(val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (includeReferences) ...[
          if (references.isEmpty)
            AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.people_outline_rounded,
                      size: 40, color: AppColors.primary),
                  const SizedBox(height: 12),
                  const Text(
                    'No references added',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add trusted colleagues or past managers who can vouch for your work.',
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
                    text: '+ Add Reference',
                    width: 180,
                    height: 44,
                    onPressed: _addNewReference,
                  ),
                ],
              ),
            )
          else
            ...List.generate(references.length, (index) {
              final ref = references[index];
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
                          child: const Icon(Icons.person_pin_rounded,
                              size: 18, color: AppColors.primary),
                        ),
                        title: Text(
                          ref.name.isNotEmpty
                              ? ref.name
                              : 'Referee Name',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text(
                          ref.company.isNotEmpty
                              ? '${ref.jobTitle} • ${ref.company}'
                              : 'Add job title & company',
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
                                label: 'Full Name',
                                hintText: 'e.g. Sarah Jenkins',
                                initialValue: ref.name,
                                isRequired: true,
                                onChanged: (val) => provider.updateReference(
                                    index, ref.copyWith(name: val)),
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Job Title',
                                hintText: 'e.g. Engineering Director',
                                initialValue: ref.jobTitle,
                                onChanged: (val) => provider.updateReference(
                                    index, ref.copyWith(jobTitle: val)),
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Company / Organization',
                                hintText: 'e.g. TechFlow Systems',
                                initialValue: ref.company,
                                onChanged: (val) => provider.updateReference(
                                    index, ref.copyWith(company: val)),
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Email Address',
                                hintText: 'sarah.jenkins@company.com',
                                initialValue: ref.email,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (val) => provider.updateReference(
                                    index, ref.copyWith(email: val)),
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                label: 'Phone Number',
                                hintText: '+1 (555) 890-1234',
                                initialValue: ref.phone,
                                keyboardType: TextInputType.phone,
                                onChanged: (val) => provider.updateReference(
                                    index, ref.copyWith(phone: val)),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 16, color: AppColors.error),
                                  label: const Text('Remove Reference',
                                      style: TextStyle(color: AppColors.error)),
                                  onPressed: () =>
                                      provider.removeReference(index),
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
            text: '+ Add Another Reference',
            variant: ButtonVariant.outline,
            onPressed: _addNewReference,
          ),
        ],
      ],
    );
  }
}
