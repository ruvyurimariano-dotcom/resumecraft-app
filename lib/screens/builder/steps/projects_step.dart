import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/project_model.dart';
import '../../../providers/resume_provider.dart';

class ProjectsStep extends StatefulWidget {
  const ProjectsStep({super.key});

  @override
  State<ProjectsStep> createState() => _ProjectsStepState();
}

class _ProjectsStepState extends State<ProjectsStep> {
  int? _expandedIndex = 0;

  void _addNewProject() {
    final provider = context.read<ResumeProvider>();
    final newProj = Project(
      projectName: '',
      role: '',
      description: '',
      technologies: [],
      projectUrl: '',
    );
    provider.addProject(newProj);
    setState(() {
      _expandedIndex = provider.activeResume.projects.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final projects = provider.activeResume.projects;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        SectionHeader(
          title: 'Projects',
          subtitle: 'Demonstrate applied expertise, open source, or side initiatives.',
          actionText: '+ Add Project',
          onAction: _addNewProject,
        ),
        const SizedBox(height: 12),

        if (projects.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.code_rounded, size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'No projects added',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Adding 1-2 featured projects dramatically improves junior and tech resumes.',
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
                  text: '+ Add Project',
                  width: 180,
                  height: 44,
                  onPressed: _addNewProject,
                ),
              ],
            ),
          )
        else
          ...List.generate(projects.length, (index) {
            final proj = projects[index];
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
                        child: const Icon(Icons.code_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                      title: Text(
                        proj.projectName.isNotEmpty
                            ? proj.projectName
                            : 'Untitled Project',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        proj.role.isNotEmpty ? proj.role : 'Add project role',
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
                              label: 'Project Name',
                              hintText: 'e.g. ResumeCraft Mobile App',
                              initialValue: proj.projectName,
                              isRequired: true,
                              onChanged: (val) => provider.updateProject(
                                  index, proj.copyWith(projectName: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Your Role',
                              hintText: 'e.g. Lead Flutter Developer',
                              initialValue: proj.role,
                              onChanged: (val) => provider.updateProject(
                                  index, proj.copyWith(role: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Technologies Used (Comma Separated)',
                              hintText: 'Flutter, Dart, Firebase, Provider',
                              initialValue: proj.technologies.join(', '),
                              onChanged: (val) {
                                final tags = val
                                    .split(',')
                                    .map((t) => t.trim())
                                    .where((t) => t.isNotEmpty)
                                    .toList();
                                provider.updateProject(
                                    index, proj.copyWith(technologies: tags));
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Project / GitHub Link',
                              hintText: 'https://github.com/username/project',
                              initialValue: proj.projectUrl,
                              keyboardType: TextInputType.url,
                              onChanged: (val) => provider.updateProject(
                                  index, proj.copyWith(projectUrl: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Project Description & Impact',
                              hintText:
                                  'Built cross-platform application achieving 10,000+ downloads with 4.8 star average rating...',
                              initialValue: proj.description,
                              maxLines: 3,
                              onChanged: (val) => provider.updateProject(
                                  index, proj.copyWith(description: val)),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.delete_outline,
                                    size: 16, color: AppColors.error),
                                label: const Text('Remove Project',
                                    style: TextStyle(color: AppColors.error)),
                                onPressed: () =>
                                    provider.removeProject(index),
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
          text: '+ Add Another Project',
          variant: ButtonVariant.outline,
          onPressed: _addNewProject,
        ),
      ],
    );
  }
}
