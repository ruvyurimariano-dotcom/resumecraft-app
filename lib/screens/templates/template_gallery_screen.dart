import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../models/template_model.dart';
import '../../services/template_service.dart';
import '../../providers/resume_provider.dart';
import '../builder/resume_builder_screen.dart';
import 'template_preview_dialog.dart';

class TemplateGalleryScreen extends StatefulWidget {
  final bool isSelectionMode;
  const TemplateGalleryScreen({super.key, this.isSelectionMode = false});

  @override
  State<TemplateGalleryScreen> createState() => _TemplateGalleryScreenState();
}

class _TemplateGalleryScreenState extends State<TemplateGalleryScreen> {
  TemplateCategory _selectedCategory = TemplateCategory.all;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final templates = TemplateService.getTemplatesByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Templates'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        fontSize: 13,
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

            // Templates Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.64,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final t = templates[index];
                  return AppCard(
                    padding: const EdgeInsets.all(12),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TemplatePreviewDialog(
                            template: t,
                            isSelectingForCurrentResume: widget.isSelectionMode,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Template Thumbnail Preview
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: t.defaultPrimaryColor.withValues(alpha: 0.3),
                                width: 1.2,
                              ),
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
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: t.defaultPrimaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    if (t.isPremium)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF59E0B),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'PRO',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 60,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: t.defaultPrimaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.black12,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const Spacer(),
                                ...List.generate(
                                  4,
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
                        const SizedBox(height: 10),

                        // Title & Category
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          t.category.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Use Template Button
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              final provider = context.read<ResumeProvider>();
                              provider.setTemplateId(t.id);
                              provider.setColorHex(
                                  '#${t.defaultPrimaryColor.value.toRadixString(16).substring(2)}');

                              if (widget.isSelectionMode) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ResumeBuilderScreen(),
                                  ),
                                );
                              }
                            },
                            child: const Text('Use Template'),
                          ),
                        ),
                      ],
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
