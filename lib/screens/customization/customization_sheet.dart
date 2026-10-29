import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../models/template_model.dart';
import '../../providers/resume_provider.dart';

class CustomizationSheet extends StatefulWidget {
  const CustomizationSheet({super.key});

  @override
  State<CustomizationSheet> createState() => _CustomizationSheetState();
}

class _CustomizationSheetState extends State<CustomizationSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _fonts = [
    {'name': 'Modern Sans', 'family': 'Roboto'},
    {'name': 'Clean Tech', 'family': 'Inter'},
    {'name': 'Classic Serif', 'family': 'Georgia'},
    {'name': 'Monospace', 'family': 'Courier'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final config = provider.activeResume.customization;

    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Customize Resume Style',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: isDark ? AppColors.primaryLight : AppColors.primary,
            indicatorColor: isDark ? AppColors.primaryLight : AppColors.primary,
            tabs: const [
              Tab(text: 'Colors'),
              Tab(text: 'Layout'),
              Tab(text: 'Fonts'),
              Tab(text: 'Sections'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Colors Tab
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('Professional Color Palettes',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: AppColors.resumePalettes.map((item) {
                        final hex = item['hex'] as String;
                        final color = item['color'] as Color;
                        final name = item['name'] as String;
                        final isSelected =
                            config.colorHex.toLowerCase() == hex.toLowerCase();

                        return GestureDetector(
                          onTap: () => provider.setColorHex(hex),
                          child: Container(
                            width: 96,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : (isDark
                                        ? AppColors.outlineDark
                                        : AppColors.outlineLight),
                                width: isSelected ? 2.2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          color: Colors.white, size: 18)
                                      : null,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // 2. Layout Tab
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('Page Layout Hierarchy',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...ResumeLayout.values.map((layout) {
                      final isSelected = config.layout == layout;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          padding: const EdgeInsets.all(14),
                          border: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.outlineDark
                                    : AppColors.outlineLight),
                            width: isSelected ? 2 : 1,
                          ),
                          onTap: () => provider.setLayout(layout),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      layout.label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      layout.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
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
                  ],
                ),

                // 3. Fonts Tab
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('Typography Pairings',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ..._fonts.map((f) {
                      final isSelected = config.fontFamily == f['family'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          padding: const EdgeInsets.all(14),
                          border: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.outlineDark
                                    : AppColors.outlineLight),
                            width: isSelected ? 2 : 1,
                          ),
                          onTap: () {
                            provider.updateCustomization(
                              config.copyWith(fontFamily: f['family']),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    f['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Aa Bb Cc Dd - 12345',
                                    style: TextStyle(
                                      fontFamily: f['family'],
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded,
                                    color: AppColors.primary),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                // 4. Sections Tab
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text('Show or Hide Resume Sections',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...config.sectionVisibility.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SwitchListTile(
                          title: Text(entry.key,
                              style: const TextStyle(fontSize: 14.5)),
                          value: entry.value,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            provider.toggleSectionVisibility(entry.key, val);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
