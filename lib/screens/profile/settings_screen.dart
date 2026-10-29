import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_list_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/storage_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminders = true;
  bool _tipsNotif = true;
  bool _exportNotif = true;

  Future<void> _handleDeleteAllResumes() async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete All Resumes?',
      message:
          'This will permanently delete all your saved resumes and drafts. This action cannot be reversed.',
      confirmText: 'Delete Everything',
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      final storage = context.read<StorageService>();
      await storage.deleteAllResumes();
      await context.read<ResumeListProvider>().loadResumes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All resumes deleted.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleBackup() async {
    final storage = context.read<StorageService>();
    final json = await storage.exportBackupJson();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Backup created successfully (${json.length} bytes).'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Appearance
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('System Default'),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) themeProvider.setThemeMode(val);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light Mode'),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) themeProvider.setThemeMode(val);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark Mode'),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      if (val != null) themeProvider.setThemeMode(val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notifications
            const Text(
              'Notification Preferences',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Resume Completion Reminders'),
                    subtitle: const Text('Nudges to complete pending drafts'),
                    value: _reminders,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _reminders = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Weekly Career & ATS Tips'),
                    subtitle: const Text('Bite-sized resume advice & interview tactics'),
                    value: _tipsNotif,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _tipsNotif = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Export & Download Confirmations'),
                    value: _exportNotif,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _exportNotif = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data Management
            const Text(
              'Data & Storage',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.backup_rounded, color: AppColors.primary),
                    title: const Text('Backup Resumes (JSON)'),
                    subtitle: const Text('Export a copy of your resumes to local storage'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: _handleBackup,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                    title: const Text('Delete All Resumes', style: TextStyle(color: AppColors.error)),
                    subtitle: const Text('Remove all stored resumes and resume drafts'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: _handleDeleteAllResumes,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Account Actions
            const Text(
              'Account',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                    title: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                    onTap: () async {
                      final confirm = await ConfirmationDialog.show(
                        context,
                        title: 'Log Out?',
                        message: 'Are you sure you want to log out of ResumeCraft?',
                        confirmText: 'Log Out',
                      );
                      if (confirm == true && mounted) {
                        auth.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
