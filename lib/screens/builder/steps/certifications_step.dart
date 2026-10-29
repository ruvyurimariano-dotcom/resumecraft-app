import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/certification_model.dart';
import '../../../providers/resume_provider.dart';

class CertificationsStep extends StatefulWidget {
  const CertificationsStep({super.key});

  @override
  State<CertificationsStep> createState() => _CertificationsStepState();
}

class _CertificationsStepState extends State<CertificationsStep> {
  int? _expandedIndex = 0;

  void _addNewCertification() {
    final provider = context.read<ResumeProvider>();
    final newCert = Certification(
      certificationName: '',
      issuingOrganization: '',
      issueDate: DateTime.now(),
      credentialId: '',
      credentialUrl: '',
    );
    provider.addCertification(newCert);
    setState(() {
      _expandedIndex = provider.activeResume.certifications.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final certifications = provider.activeResume.certifications;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        SectionHeader(
          title: 'Certifications & Licenses',
          subtitle: 'Verify your technical expertise with industry credentials.',
          actionText: '+ Add Certificate',
          onAction: _addNewCertification,
        ),
        const SizedBox(height: 12),

        if (certifications.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.verified_outlined,
                    size: 40, color: AppColors.primary),
                const SizedBox(height: 12),
                const Text(
                  'No certifications added yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Include AWS, Google Cloud, Scrum Master, or professional badges.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: '+ Add Certification',
                  width: 200,
                  height: 44,
                  onPressed: _addNewCertification,
                ),
              ],
            ),
          )
        else
          ...List.generate(certifications.length, (index) {
            final cert = certifications[index];
            final isExpanded = _expandedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.verified_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                      title: Text(
                        cert.certificationName.isNotEmpty
                            ? cert.certificationName
                            : 'Certification Title',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Text(
                        cert.issuingOrganization.isNotEmpty
                            ? cert.issuingOrganization
                            : 'Add issuer',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                        ),
                        onPressed: () {
                          setState(() {
                            _expandedIndex = isExpanded ? null : index;
                          });
                        },
                      ),
                    ),

                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: 'Certification Name',
                              hintText: 'e.g. AWS Certified Solutions Architect',
                              initialValue: cert.certificationName,
                              isRequired: true,
                              onChanged: (val) => provider.updateCertification(
                                  index, cert.copyWith(certificationName: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Issuing Organization',
                              hintText: 'e.g. Amazon Web Services',
                              initialValue: cert.issuingOrganization,
                              isRequired: true,
                              onChanged: (val) => provider.updateCertification(
                                  index, cert.copyWith(issuingOrganization: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Credential ID',
                              hintText: 'e.g. AWS-PSA-920194',
                              initialValue: cert.credentialId,
                              onChanged: (val) => provider.updateCertification(
                                  index, cert.copyWith(credentialId: val)),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              label: 'Credential Verification URL',
                              hintText: 'https://credly.com/badges/...',
                              initialValue: cert.credentialUrl,
                              keyboardType: TextInputType.url,
                              onChanged: (val) => provider.updateCertification(
                                  index, cert.copyWith(credentialUrl: val)),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.delete_outline,
                                    size: 16, color: AppColors.error),
                                label: const Text('Remove Certificate',
                                    style: TextStyle(color: AppColors.error)),
                                onPressed: () =>
                                    provider.removeCertification(index),
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

        const SizedBox(height: 16),
        CustomButton(
          text: '+ Add Another Certificate',
          variant: ButtonVariant.outline,
          onPressed: _addNewCertification,
        ),
      ],
    );
  }
}
