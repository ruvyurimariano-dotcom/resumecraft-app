import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/skill_model.dart';
import '../../../providers/resume_provider.dart';
import '../../../services/ai_service.dart';

class SkillsStep extends StatefulWidget {
  const SkillsStep({super.key});

  @override
  State<SkillsStep> createState() => _SkillsStepState();
}

class _SkillsStepState extends State<SkillsStep> {
  final _customSkillController = TextEditingController();
  SkillLevel _selectedLevel = SkillLevel.advanced;
  List<String> _suggestions = [
    'Flutter',
    'Dart',
    'Kotlin',
    'Android SDK',
    'Firebase',
    'REST APIs',
    'GraphQL',
    'Git & GitHub',
    'CI/CD',
    'UI/UX Design',
    'Problem Solving',
    'Agile Leadership',
  ];

  @override
  void initState() {
    super.initState();
    _loadSmartSuggestions();
  }

  Future<void> _loadSmartSuggestions() async {
    final title =
        context.read<ResumeProvider>().activeResume.personalInfo.professionalTitle;
    if (title.isNotEmpty) {
      final aiSkills = await AiService.suggestSkillsForTitle(title);
      if (mounted && aiSkills.isNotEmpty) {
        setState(() {
          _suggestions = aiSkills;
        });
      }
    }
  }

  @override
  void dispose() {
    _customSkillController.dispose();
    super.dispose();
  }

  void _addSkill(String name, SkillLevel level) {
    if (name.trim().isEmpty) return;
    final provider = context.read<ResumeProvider>();
    final exists = provider.activeResume.skills
        .any((s) => s.name.toLowerCase() == name.trim().toLowerCase());
    if (!exists) {
      provider.addSkill(Skill(name: name.trim(), level: level));
    }
    _customSkillController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final skills = provider.activeResume.skills;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const SectionHeader(
          title: 'Skills & Proficiencies',
          subtitle: 'Add keywords to maximize match rates with applicant tracking systems.',
        ),
        const SizedBox(height: 12),

        // Custom Skill Input Card
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Skill',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customSkillController,
                      onSubmitted: (val) => _addSkill(val, _selectedLevel),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Flutter, Kotlin, Figma...',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<SkillLevel>(
                    value: _selectedLevel,
                    underline: const SizedBox(),
                    items: SkillLevel.values
                        .map((l) => DropdownMenuItem(
                              value: l,
                              child: Text(l.label,
                                  style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedLevel = val);
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    icon: const Icon(Icons.add_rounded, size: 20),
                    onPressed: () => _addSkill(
                      _customSkillController.text,
                      _selectedLevel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Smart Suggestions Chips
        const Text(
          'Recommended for Your Role',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions.map((s) {
            final isAlreadyAdded = skills
                .any((sk) => sk.name.toLowerCase() == s.toLowerCase());

            return ActionChip(
              avatar: Icon(
                isAlreadyAdded ? Icons.check_circle_rounded : Icons.add_rounded,
                size: 16,
                color: isAlreadyAdded ? AppColors.success : AppColors.primary,
              ),
              label: Text(s),
              labelStyle: TextStyle(
                fontSize: 12,
                color: isAlreadyAdded ? AppColors.success : null,
                fontWeight: isAlreadyAdded ? FontWeight.bold : FontWeight.w500,
              ),
              backgroundColor: isAlreadyAdded
                  ? AppColors.successContainer.withValues(alpha: 0.4)
                  : null,
              onPressed: isAlreadyAdded
                  ? null
                  : () => _addSkill(s, SkillLevel.advanced),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Added Skills List
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Added Skills (${skills.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            if (skills.length < 6)
              const Text(
                'Add 6+ for optimal ATS score',
                style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (skills.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
              ),
            ),
            child: const Text('No skills added yet. Tap suggestions above or type one in!'),
          )
        else
          ...List.generate(skills.length, (index) {
            final sk = skills[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sk.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: sk.level.percentage,
                                minHeight: 6,
                                backgroundColor: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE2E8F0),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            sk.level.label,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 16),
                      onPressed: () => provider.removeSkill(index),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
