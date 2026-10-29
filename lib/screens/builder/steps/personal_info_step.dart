import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../models/resume_model.dart';
import '../../../providers/resume_provider.dart';

class PersonalInfoStep extends StatefulWidget {
  const PersonalInfoStep({super.key});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, maxWidth: 600);
      if (picked != null && mounted) {
        final provider = context.read<ResumeProvider>();
        final current = provider.activeResume.personalInfo;
        provider.updatePersonalInfo(current.copyWith(profilePhoto: picked.path));
      }
    } catch (_) {
      // Permission or cancel
    }
  }

  void _selectPresetPhoto(String url) {
    final provider = context.read<ResumeProvider>();
    final current = provider.activeResume.personalInfo;
    provider.updatePersonalInfo(current.copyWith(profilePhoto: url));
  }

  void _removePhoto() {
    final provider = context.read<ResumeProvider>();
    final current = provider.activeResume.personalInfo;
    provider.updatePersonalInfo(current.copyWith(profilePhoto: ''));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final info = provider.activeResume.personalInfo;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Profile Photo Avatar & Action
        Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : AppColors.primaryContainer,
                    backgroundImage: info.profilePhoto.isNotEmpty
                        ? (info.profilePhoto.startsWith('http')
                            ? NetworkImage(info.profilePhoto) as ImageProvider
                            : AssetImage(info.profilePhoto))
                        : null,
                    child: info.profilePhoto.isEmpty
                        ? const Icon(
                            Icons.person_rounded,
                            size: 48,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onSelected: (val) {
                          if (val == 'gallery') {
                            _pickImage(ImageSource.gallery);
                          } else if (val == 'camera') {
                            _pickImage(ImageSource.camera);
                          } else if (val == 'preset') {
                            _selectPresetPhoto(AppAssets.presetAvatars.first);
                          } else if (val == 'remove') {
                            _removePhoto();
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'gallery',
                            child: Row(
                              children: [
                                Icon(Icons.photo_library_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Choose from Gallery'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'camera',
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Take Photo'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'preset',
                            child: Row(
                              children: [
                                Icon(Icons.face_rounded, size: 18),
                                SizedBox(width: 8),
                                Text('Use Professional Preset'),
                              ],
                            ),
                          ),
                          if (info.profilePhoto.isNotEmpty)
                            const PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 18, color: AppColors.error),
                                  SizedBox(width: 8),
                                  Text('Remove Photo',
                                      style: TextStyle(color: AppColors.error)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                info.profilePhoto.isEmpty
                    ? 'Add Professional Photo'
                    : 'Change Photo',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Full Name
        CustomTextField(
          label: 'Full Name',
          hintText: 'e.g. Alex Morgan',
          initialValue: info.fullName,
          isRequired: true,
          prefixIcon: const Icon(Icons.person_outline, size: 20),
          onChanged: (val) => provider.updatePersonalInfo(info.copyWith(fullName: val)),
          validator: (val) => Validators.requiredField(val, fieldName: 'Full name'),
        ),
        const SizedBox(height: 16),

        // Professional Title
        CustomTextField(
          label: 'Professional Title',
          hintText: 'e.g. Senior Full Stack Engineer',
          initialValue: info.professionalTitle,
          isRequired: true,
          prefixIcon: const Icon(Icons.badge_outlined, size: 20),
          onChanged: (val) =>
              provider.updatePersonalInfo(info.copyWith(professionalTitle: val)),
          validator: (val) =>
              Validators.requiredField(val, fieldName: 'Professional title'),
        ),
        const SizedBox(height: 16),

        // Email
        CustomTextField(
          label: 'Email Address',
          hintText: 'alex.morgan@example.com',
          initialValue: info.email,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, size: 20),
          onChanged: (val) => provider.updatePersonalInfo(info.copyWith(email: val)),
          validator: Validators.email,
        ),
        const SizedBox(height: 16),

        // Phone
        CustomTextField(
          label: 'Phone Number',
          hintText: '+1 (555) 234-5678',
          initialValue: info.phone,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_outlined, size: 20),
          onChanged: (val) => provider.updatePersonalInfo(info.copyWith(phone: val)),
          validator: Validators.phone,
        ),
        const SizedBox(height: 16),

        // Location
        CustomTextField(
          label: 'Location / City, Country',
          hintText: 'San Francisco, CA',
          initialValue: info.location,
          prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
          onChanged: (val) => provider.updatePersonalInfo(info.copyWith(location: val)),
        ),
        const SizedBox(height: 16),

        // LinkedIn
        CustomTextField(
          label: 'LinkedIn Profile',
          hintText: 'https://linkedin.com/in/username',
          initialValue: info.linkedIn,
          keyboardType: TextInputType.url,
          prefixIcon: const Icon(Icons.link_rounded, size: 20),
          onChanged: (val) => provider.updatePersonalInfo(info.copyWith(linkedIn: val)),
          validator: Validators.url,
        ),
        const SizedBox(height: 16),

        // Website / Portfolio
        CustomTextField(
          label: 'Website / Portfolio',
          hintText: 'https://yourportfolio.com',
          initialValue: info.website,
          keyboardType: TextInputType.url,
          prefixIcon: const Icon(Icons.language_rounded, size: 20),
          onChanged: (val) => provider.updatePersonalInfo(info.copyWith(website: val)),
          validator: Validators.url,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
