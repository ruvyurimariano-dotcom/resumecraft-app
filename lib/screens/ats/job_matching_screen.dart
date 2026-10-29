import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/ats_result_model.dart';
import '../../providers/resume_provider.dart';
import '../../services/ats_service.dart';

class JobMatchingScreen extends StatefulWidget {
  const JobMatchingScreen({super.key});

  @override
  State<JobMatchingScreen> createState() => _JobMatchingScreenState();
}

class _JobMatchingScreenState extends State<JobMatchingScreen> {
  final _jdController = TextEditingController();
  bool _isAnalyzing = false;
  JobMatchResult? _result;

  @override
  void dispose() {
    _jdController.dispose();
    super.dispose();
  }

  void _pasteSampleJob() {
    _jdController.text =
        'We are seeking a Senior Mobile Engineer with strong experience in Flutter, Dart, and REST APIs. The ideal candidate has experience leading Agile teams, implementing CI/CD pipelines, Docker, automated unit testing, and architecture optimization for high-scale applications.';
  }

  Future<void> _analyzeJob() async {
    if (_jdController.text.trim().isEmpty) return;

    setState(() => _isAnalyzing = true);
    final resume = context.read<ResumeProvider>().activeResume;
    final res = await AtsService.matchJobDescription(
      resume: resume,
      jobDescription: _jdController.text,
    );
    setState(() {
      _isAnalyzing = false;
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Resume to Job'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Job Description Matcher',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Paste the target job posting to uncover missing keywords, skill gaps, and custom resume alignment recommendations.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 16),

              // JD Input
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Paste Job Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.5),
                        ),
                        TextButton(
                          onPressed: _pasteSampleJob,
                          child: const Text('Paste Sample JD',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _jdController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText:
                            'Paste the requirements, responsibilities, and qualifications from the job posting...',
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomButton(
                      text: 'Analyze Job Match',
                      icon: Icons.radar_rounded,
                      isLoading: _isAnalyzing,
                      onPressed: _analyzeJob,
                    ),
                  ],
                ),
              ),

              // Results
              if (_result != null) ...[
                const SizedBox(height: 24),
                // Match percentage header
                AppCard(
                  padding: const EdgeInsets.all(20),
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : AppColors.primaryContainer.withValues(alpha: 0.35),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${_result!.matchPercentage}%',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _result!.matchPercentage >= 75
                                  ? 'Strong Match!'
                                  : 'Moderate Match',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Your resume matches ${_result!.matchPercentage}% of key qualifications.',
                              style: TextStyle(
                                fontSize: 12.5,
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
                const SizedBox(height: 18),

                // Matched Keywords
                const Text(
                  'Matching Keywords in Your Resume',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _result!.matchedKeywords.map((k) {
                    return Chip(
                      avatar: const Icon(Icons.check_circle_rounded,
                          size: 16, color: AppColors.success),
                      label: Text(k),
                      labelStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success),
                      backgroundColor:
                          AppColors.successContainer.withValues(alpha: 0.5),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // Missing Keywords
                const Text(
                  'Missing Keywords from Job Posting',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _result!.missingKeywords.map((k) {
                    return Chip(
                      avatar: const Icon(Icons.add_circle_outline_rounded,
                          size: 16, color: AppColors.error),
                      label: Text(k),
                      labelStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error),
                      backgroundColor:
                          AppColors.errorContainer.withValues(alpha: 0.5),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Recommended Improvements
                const Text(
                  'Actionable Alignment Tips',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ..._result!.improvements.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_right_rounded,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
