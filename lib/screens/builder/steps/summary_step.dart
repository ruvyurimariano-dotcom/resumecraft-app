import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../providers/resume_provider.dart';
import '../../../services/ai_service.dart';
import '../../ai/ai_assistant_bottom_sheet.dart';

class SummaryStep extends StatefulWidget {
  const SummaryStep({super.key});

  @override
  State<SummaryStep> createState() => _SummaryStepState();
}

class _SummaryStepState extends State<SummaryStep> {
  late TextEditingController _controller;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    final currentSummary =
        context.read<ResumeProvider>().activeResume.summary;
    _controller = TextEditingController(text: currentSummary);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyAiAction(String action) async {
    setState(() => _isGenerating = true);
    final provider = context.read<ResumeProvider>();
    final title = provider.activeResume.personalInfo.professionalTitle;
    final skills = provider.activeResume.skills.map((s) => s.name).toList();

    String result;
    if (action == 'generate' || _controller.text.trim().isEmpty) {
      result = await AiService.generateSummary(title: title, skills: skills);
    } else {
      result = await AiService.rewriteSummary(
        existingSummary: _controller.text,
        style: action,
      );
    }

    setState(() {
      _controller.text = result;
      _isGenerating = false;
    });
    provider.updateSummary(result);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final wordCount = _controller.text.trim().isEmpty
        ? 0
        : _controller.text.trim().split(RegExp(r'\s+')).length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // AI Header Callout
        AppCard(
          padding: const EdgeInsets.all(16),
          color: isDark
              ? const Color(0xFF1E293B)
              : AppColors.primaryContainer.withValues(alpha: 0.35),
          border: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Summary Assistant',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                    tooltip: 'Open AI Assistant',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const AiAssistantBottomSheet(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Generate an engaging, recruiter-optimized 2-3 sentence overview of your career and accomplishments.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 12),
              // AI Quick Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _aiActionChip('Generate with AI', 'generate', Icons.bolt_rounded),
                    const SizedBox(width: 8),
                    _aiActionChip('Make Professional', 'professional', Icons.business_center_outlined),
                    const SizedBox(width: 8),
                    _aiActionChip('Make ATS Friendly', 'ats', Icons.fact_check_outlined),
                    const SizedBox(width: 8),
                    _aiActionChip('Shorten', 'shorten', Icons.compress_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Text Area with Character and Word Count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Professional Summary',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$wordCount words • ${_controller.text.length} chars',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_isGenerating)
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 2),
                SizedBox(height: 12),
                Text('Polishing summary with AI...'),
              ],
            ),
          )
        else
          TextFormField(
            controller: _controller,
            maxLines: 7,
            minLines: 5,
            onChanged: (val) => provider.updateSummary(val),
            decoration: InputDecoration(
              hintText:
                  'e.g. Results-driven Software Developer with 4+ years of experience building responsive mobile and cloud applications. Proven track record in optimizing app performance by 35% and collaborating with agile engineering teams...',
              filled: true,
              fillColor: isDark ? AppColors.surfaceDark : Colors.white,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        const SizedBox(height: 16),

        // Tips Callout
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tip: Recruiter eye-tracking studies show summaries get 6 seconds of attention. Keep it concise, highlighting years of experience and top skills.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _aiActionChip(String label, String action, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: AppColors.primary),
      label: Text(label),
      labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
      onPressed: () => _applyAiAction(action),
    );
  }
}
