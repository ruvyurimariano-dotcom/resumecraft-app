import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/language_model.dart';
import '../../../providers/resume_provider.dart';

class LanguagesStep extends StatefulWidget {
  const LanguagesStep({super.key});

  @override
  State<LanguagesStep> createState() => _LanguagesStepState();
}

class _LanguagesStepState extends State<LanguagesStep> {
  final _languageController = TextEditingController();
  LanguageProficiency _selectedProficiency = LanguageProficiency.fluent;

  final List<String> _popularLanguages = [
    'English',
    'Spanish',
    'Mandarin',
    'French',
    'German',
    'Japanese',
    'Arabic',
    'Portuguese',
  ];

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  void _addLanguage(String name, LanguageProficiency proficiency) {
    if (name.trim().isEmpty) return;
    final provider = context.read<ResumeProvider>();
    final exists = provider.activeResume.languages
        .any((l) => l.language.toLowerCase() == name.trim().toLowerCase());
    if (!exists) {
      provider.addLanguage(
          Language(language: name.trim(), proficiency: proficiency));
    }
    _languageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final languages = provider.activeResume.languages;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const SectionHeader(
          title: 'Languages',
          subtitle: 'List languages you can speak or write in professional settings.',
        ),
        const SizedBox(height: 12),

        // Quick Input Card
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Language',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _languageController,
                      onSubmitted: (val) =>
                          _addLanguage(val, _selectedProficiency),
                      decoration: const InputDecoration(
                        hintText: 'e.g. English, Spanish, German...',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<LanguageProficiency>(
                    value: _selectedProficiency,
                    underline: const SizedBox(),
                    items: LanguageProficiency.values
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.label,
                                  style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedProficiency = val);
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    icon: const Icon(Icons.add_rounded, size: 20),
                    onPressed: () => _addLanguage(
                      _languageController.text,
                      _selectedProficiency,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick suggestions
        const Text(
          'Quick Suggestions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularLanguages.map((lang) {
            final isAdded = languages
                .any((l) => l.language.toLowerCase() == lang.toLowerCase());
            return ActionChip(
              avatar: Icon(
                isAdded ? Icons.check_circle_rounded : Icons.add_rounded,
                size: 16,
                color: isAdded ? AppColors.success : AppColors.primary,
              ),
              label: Text(lang),
              backgroundColor: isAdded
                  ? AppColors.successContainer.withOpacity( 0.4)
                  : null,
              onPressed: isAdded
                  ? null
                  : () => _addLanguage(lang, LanguageProficiency.fluent),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Added Languages List
        Text(
          'Added Languages (${languages.length})',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 10),

        if (languages.isEmpty)
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
            child: const Text('No languages added yet.'),
          )
        else
          ...List.generate(languages.length, (index) {
            final lang = languages[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.translate_rounded,
                        size: 20, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lang.language,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        lang.proficiency.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => provider.removeLanguage(index),
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
