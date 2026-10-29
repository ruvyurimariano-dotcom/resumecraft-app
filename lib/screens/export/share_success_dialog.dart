import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/resume_model.dart';
import '../../services/share_service.dart';
import '../builder/resume_type_selector_screen.dart';

class ShareSuccessDialog extends StatelessWidget {
  final Resume resume;

  const ShareSuccessDialog({super.key, required this.resume});

  static Future<void> show(BuildContext context, Resume resume) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ShareSuccessDialog(resume: resume),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.successContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 44,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Resume is Ready!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'PDF successfully generated and saved. You can now share it directly with hiring managers or job portals.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Share via Android Share Sheet',
            icon: Icons.share_rounded,
            onPressed: () {
              Navigator.of(context).pop();
              ShareService.shareResumePdf(context: context, resume: resume);
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Share as Plain Text',
            variant: ButtonVariant.outline,
            icon: Icons.text_snippet_outlined,
            onPressed: () {
              Navigator.of(context).pop();
              ShareService.shareResumeText(context: context, resume: resume);
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Create Another Resume',
            variant: ButtonVariant.text,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ResumeTypeSelectorScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
