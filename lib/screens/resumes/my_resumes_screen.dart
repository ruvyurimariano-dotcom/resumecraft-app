import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../models/resume_model.dart';
import '../../providers/resume_list_provider.dart';
import '../../providers/resume_provider.dart';
import '../builder/resume_type_selector_screen.dart';
import '../builder/resume_builder_screen.dart';
import '../preview/live_preview_screen.dart';
import '../export/export_screen.dart';
import '../../services/share_service.dart';

class MyResumesScreen extends StatelessWidget {
  const MyResumesScreen({super.key});

  Future<void> _showRenameDialog(
      BuildContext context, Resume resume, ResumeListProvider provider) async {
    final controller = TextEditingController(text: resume.title);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Resume'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter resume name',
            labelText: 'Resume Title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      await provider.renameResume(resume.id, newName);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, Resume resume, ResumeListProvider provider) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Resume?',
      message:
          'Are you sure you want to permanently delete "${resume.title}"? This action cannot be undone.',
      confirmText: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true) {
      await provider.deleteResume(resume.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${resume.title}"'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resumeList = context.watch<ResumeListProvider>();
    final resumes = resumeList.resumes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resumes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create Resume',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ResumeTypeSelectorScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: resumes.isEmpty && !resumeList.isLoading
            ? EmptyStateView(
                icon: Icons.folder_open_rounded,
                title: "You haven't created a resume yet.",
                description:
                    'Create your first professional resume with tailored AI suggestions and modern templates.',
                buttonText: 'Create Your First Resume',
                onButtonPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ResumeTypeSelectorScreen(),
                    ),
                  );
                },
              )
            : RefreshIndicator(
                onRefresh: () => resumeList.loadResumes(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: (val) => resumeList.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search resumes by title, role or skill...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        suffixIcon: resumeList.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () => resumeList.setSearchQuery(''),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Resume List Cards
                    ...resumes.map((r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppCard(
                            padding: const EdgeInsets.all(16),
                            onTap: () {
                              context.read<ResumeProvider>().setActiveResume(r);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LivePreviewScreen(),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.primary
                                              .withOpacity( 0.25),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.description_rounded,
                                        color: AppColors.primary,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${r.resumeType} • ${DateFormatter.formatMonthYear(r.updatedAt)}',
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
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.more_vert_rounded),
                                      onSelected: (val) async {
                                        context
                                            .read<ResumeProvider>()
                                            .setActiveResume(r);
                                        switch (val) {
                                          case 'edit':
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ResumeBuilderScreen(),
                                              ),
                                            );
                                            break;
                                          case 'preview':
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LivePreviewScreen(),
                                              ),
                                            );
                                            break;
                                          case 'rename':
                                            await _showRenameDialog(
                                                context, r, resumeList);
                                            break;
                                          case 'duplicate':
                                            await resumeList.duplicateResume(r.id);
                                            break;
                                          case 'download':
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ExportScreen(),
                                              ),
                                            );
                                            break;
                                          case 'share':
                                            await ShareService.shareResumePdf(
                                              context: context,
                                              resume: r,
                                            );
                                            break;
                                          case 'delete':
                                            await _confirmDelete(
                                                context, r, resumeList);
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit_outlined, size: 18),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'preview',
                                          child: Row(
                                            children: [
                                              Icon(Icons.visibility_outlined,
                                                  size: 18),
                                              SizedBox(width: 8),
                                              Text('Preview'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'rename',
                                          child: Row(
                                            children: [
                                              Icon(Icons.drive_file_rename_outline,
                                                  size: 18),
                                              SizedBox(width: 8),
                                              Text('Rename'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'duplicate',
                                          child: Row(
                                            children: [
                                              Icon(Icons.copy_outlined, size: 18),
                                              SizedBox(width: 8),
                                              Text('Duplicate'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'download',
                                          child: Row(
                                            children: [
                                              Icon(Icons.download_rounded,
                                                  size: 18),
                                              SizedBox(width: 8),
                                              Text('Download PDF'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'share',
                                          child: Row(
                                            children: [
                                              Icon(Icons.share_outlined, size: 18),
                                              SizedBox(width: 8),
                                              Text('Share'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline,
                                                  size: 18, color: AppColors.error),
                                              SizedBox(width: 8),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      color: AppColors.error)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Completion indicator
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: r.completionPercentage,
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
                                    const SizedBox(width: 12),
                                    Text(
                                      '${(r.completionPercentage * 100).toInt()}% Complete',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
      ),
      floatingActionButton: resumes.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ResumeTypeSelectorScreen(),
                  ),
                );
              },
              backgroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
              foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Resume'),
            )
          : null,
    );
  }
}
