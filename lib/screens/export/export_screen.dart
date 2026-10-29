import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/resume_provider.dart';
import '../../services/pdf_service.dart';
import '../../services/share_service.dart';
import 'share_success_dialog.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _format = 'PDF'; // 'PDF' or 'TEXT'
  PdfPageFormat _pageFormat = PdfPageFormat.a4;
  bool _includePhoto = true;
  bool _includeLinks = true;
  bool _compress = false;
  bool _isGenerating = false;

  Future<void> _handleExport() async {
    final resume = context.read<ResumeProvider>().activeResume;
    setState(() => _isGenerating = true);

    try {
      if (_format == 'PDF') {
        final pdfBytes = await PdfService.generateResumePdf(
          resume: resume,
          pageFormat: _pageFormat,
          includePhoto: _includePhoto,
          includeLinks: _includeLinks,
          compress: _compress,
        );

        final filename =
            '${resume.personalInfo.fullName.replaceAll(' ', '_')}_Resume.pdf';

        setState(() => _isGenerating = false);

        if (mounted) {
          // Open printing/saving preview dialog
          await Printing.layoutPdf(
            onLayout: (format) async => pdfBytes,
            name: filename,
          );

          if (mounted) {
            ShareSuccessDialog.show(context, resume);
          }
        }
      } else {
        setState(() => _isGenerating = false);
        await ShareService.shareResumeText(context: context, resume: resume);
      }
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleShare() async {
    final resume = context.read<ResumeProvider>().activeResume;
    if (_format == 'PDF') {
      await ShareService.shareResumePdf(context: context, resume: resume);
    } else {
      await ShareService.shareResumeText(context: context, resume: resume);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resume = context.watch<ResumeProvider>().activeResume;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.exportTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Resume Meta Card
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resume.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${resume.personalInfo.fullName} • ${resume.resumeType}',
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
                  const SizedBox(height: 20),

                  // Export Format Selector
                  const Text(
                    'Export Format',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _formatCard(
                          title: 'PDF Document',
                          subtitle: 'High-res, ATS-compliant vectorized layout',
                          icon: Icons.picture_as_pdf_rounded,
                          isSelected: _format == 'PDF',
                          onTap: () => setState(() => _format = 'PDF'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _formatCard(
                          title: 'Plain Text',
                          subtitle: 'Simple clipboard format for online forms',
                          icon: Icons.text_snippet_outlined,
                          isSelected: _format == 'TEXT',
                          onTap: () => setState(() => _format = 'TEXT'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // PDF Settings
                  if (_format == 'PDF') ...[
                    const Text(
                      'Page Size & Settings',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Page Size',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              SegmentedButton<PdfPageFormat>(
                                segments: const [
                                  ButtonSegment(
                                    value: PdfPageFormat.a4,
                                    label: Text('A4 (Standard)'),
                                  ),
                                  ButtonSegment(
                                    value: PdfPageFormat.letter,
                                    label: Text('US Letter'),
                                  ),
                                ],
                                selected: {_pageFormat},
                                onSelectionChanged: (set) {
                                  setState(() {
                                    _pageFormat = set.first;
                                  });
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                          SwitchListTile(
                            title: const Text('Include Profile Photo',
                                style: TextStyle(fontSize: 14)),
                            value: _includePhoto,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) =>
                                setState(() => _includePhoto = val),
                          ),
                          SwitchListTile(
                            title: const Text('Include Clickable Links',
                                style: TextStyle(fontSize: 14)),
                            value: _includeLinks,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) =>
                                setState(() => _includeLinks = val),
                          ),
                          SwitchListTile(
                            title: const Text('Compress PDF File Size',
                                style: TextStyle(fontSize: 14)),
                            subtitle: const Text(
                              'Optimized under 1MB for email attachments',
                              style: TextStyle(fontSize: 11.5),
                            ),
                            value: _compress,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) =>
                                setState(() => _compress = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Bottom Buttons
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
              child: Column(
                children: [
                  CustomButton(
                    text: _format == 'PDF' ? AppStrings.downloadPdf : 'Export Text',
                    icon: Icons.download_rounded,
                    isLoading: _isGenerating,
                    onPressed: _handleExport,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: AppStrings.shareResume,
                    variant: ButtonVariant.outline,
                    icon: Icons.share_rounded,
                    onPressed: _handleShare,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.all(14),
      border: BorderSide(
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.outlineDark : AppColors.outlineLight),
        width: isSelected ? 2 : 1,
      ),
      color: isSelected
          ? (isDark
              ? const Color(0xFF1E293B)
              : AppColors.primaryContainer.withOpacity( 0.3))
          : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.primaryLight : AppColors.primary),
              size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
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
  }
}
