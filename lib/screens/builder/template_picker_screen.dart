import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/template_model.dart';
import '../../services/template_service.dart';
import '../../providers/resume_list_provider.dart';
import '../../providers/resume_provider.dart';
import 'resume_builder_screen.dart';

class TemplatePickerScreen extends StatefulWidget {
  final String resumeType;
  const TemplatePickerScreen({super.key, required this.resumeType});

  @override
  State<TemplatePickerScreen> createState() => _TemplatePickerScreenState();
}

class _TemplatePickerScreenState extends State<TemplatePickerScreen> {
  TemplateCategory _selectedCategory = TemplateCategory.all;
  String _selectedTemplateId = 'modern_pro';
  bool _isLoading = false;

  Future<void> _handleStartBuilding() async {
    setState(() => _isLoading = true);
    final resumeList = context.read<ResumeListProvider>();
    final resumeProvider = context.read<ResumeProvider>();

    final selectedTemplate = TemplateService.getTemplateById(_selectedTemplateId);

    final newResume = await resumeList.createNewResume(
      title: '${widget.resumeType} 1',
      resumeType: widget.resumeType,
      templateId: _selectedTemplateId,
    );

    // Apply template color
    final updated = newResume.copyWith(
      customization: newResume.customization.copyWith(
        templateId: selectedTemplate.id,
        colorHex:
            '#${selectedTemplate.defaultPrimaryColor.value.toRadixString(16).substring(2)}',
      ),
    );

    resumeProvider.setActiveResume(updated);
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ResumeBuilderScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final templates = TemplateService.getTemplatesByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Template'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 2 of 2',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select a Layout Design',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You can change colors, fonts, and layouts at any time.',
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
            const SizedBox(height: 10),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: TemplateCategory.values.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat.label),
                      selectedColor: isDark
                          ? const Color(0xFF1E3A8A)
                          : AppColors.primaryContainer,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? AppColors.primaryLight : AppColors.primary)
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Grid of Templates
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final t = templates[index];
                  final isSelected = _selectedTemplateId == t.id;

                  return AppCard(
                    padding: const EdgeInsets.all(12),
                    border: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.outlineDark
                              : AppColors.outlineLight),
                      width: isSelected ? 2.2 : 1,
                    ),
                    color: isSelected
                        ? (isDark
                            ? const Color(0xFF1E293B)
                            : AppColors.primaryContainer.withValues(alpha: 0.2))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedTemplateId = t.id;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Thumbnail
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: t.defaultPrimaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primary,
                                        size: 18,
                                      )
                                    else if (t.isPremium)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF59E0B),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: const Text(
                                          'PRO',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: t.defaultPrimaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const Spacer(),
                                ...List.generate(
                                  3,
                                  (i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Container(
                                      width: double.infinity,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.white12
                                            : Colors.black12,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.name,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? (isDark
                                    ? AppColors.primaryLight
                                    : AppColors.primary)
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          t.category.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom CTA
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
                text: 'Start Building',
                icon: Icons.edit_document,
                isLoading: _isLoading,
                onPressed: _handleStartBuilding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
