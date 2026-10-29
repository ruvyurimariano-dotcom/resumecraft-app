import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/resume_provider.dart';
import '../../services/ai_service.dart';

class AiAssistantBottomSheet extends StatefulWidget {
  final String? initialContextText;
  const AiAssistantBottomSheet({super.key, this.initialContextText});

  @override
  State<AiAssistantBottomSheet> createState() => _AiAssistantBottomSheetState();
}

class _AiAssistantBottomSheetState extends State<AiAssistantBottomSheet> {
  final _inputController = TextEditingController();
  final _resultController = TextEditingController();
  bool _isLoading = false;

  final List<String> _quickPrompts = [
    'Write Summary',
    'Improve Experience',
    'Make ATS Friendly',
    'Add Achievements',
    'Suggest Skills',
    'Shorten Text',
    'Make Professional',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialContextText != null &&
        widget.initialContextText!.isNotEmpty) {
      _inputController.text = widget.initialContextText!;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  Future<void> _processAiPrompt(String prompt) async {
    setState(() => _isLoading = true);
    final provider = context.read<ResumeProvider>();
    final title = provider.activeResume.personalInfo.professionalTitle;
    final skills = provider.activeResume.skills.map((s) => s.name).toList();

    String generated = '';
    switch (prompt.toLowerCase()) {
      case 'write summary':
        generated = await AiService.generateSummary(title: title, skills: skills);
        break;
      case 'make ats friendly':
        generated = await AiService.rewriteSummary(
          existingSummary: _inputController.text,
          style: 'ats',
        );
        break;
      case 'make professional':
        generated = await AiService.rewriteSummary(
          existingSummary: _inputController.text,
          style: 'professional',
        );
        break;
      case 'shorten text':
        generated = await AiService.rewriteSummary(
          existingSummary: _inputController.text,
          style: 'shorten',
        );
        break;
      case 'add achievements':
        final bullets = await AiService.generateAchievements(
          jobTitle: title,
          company: 'Company',
        );
        generated = bullets.map((b) => '• $b').join('\n');
        break;
      case 'suggest skills':
        final sList = await AiService.suggestSkillsForTitle(title);
        generated = sList.join(', ');
        break;
      default:
        generated = await AiService.rewriteSummary(
          existingSummary: _inputController.text,
          style: 'improve',
        );
    }

    setState(() {
      _isLoading = false;
      _resultController.text = generated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Resume Assistant',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Refine, rewrite & tailor your content',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Main Interactive Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Quick Prompt Pills
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _quickPrompts.map((p) {
                    return ActionChip(
                      avatar: const Icon(Icons.bolt_rounded,
                          size: 14, color: AppColors.primary),
                      label: Text(p),
                      labelStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                      onPressed: () => _processAiPrompt(p),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Input / Prompt Field
                const Text(
                  'Input Text or Custom Prompt',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _inputController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        'Paste your draft summary or experience description here, or write a custom prompt...',
                  ),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Enhance with AI',
                  icon: Icons.auto_awesome,
                  isLoading: _isLoading,
                  height: 44,
                  onPressed: () => _processAiPrompt('improve'),
                ),
                const SizedBox(height: 24),

                // AI Result Output Field (Fully Editable)
                if (_resultController.text.isNotEmpty || _isLoading) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AI Generated Result (Editable)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        tooltip: 'Copy to Clipboard',
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: _resultController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied to clipboard!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _resultController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Actions: Insert, Replace, Cancel
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Insert into Summary',
                          icon: Icons.check_rounded,
                          height: 44,
                          onPressed: () {
                            provider.updateSummary(_resultController.text);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Summary updated!'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        text: 'Regenerate',
                        variant: ButtonVariant.outline,
                        width: 120,
                        height: 44,
                        onPressed: () => _processAiPrompt('improve'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
