import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/resume_model.dart';
import '../../models/template_model.dart';

class ResumeCanvasWidget extends StatelessWidget {
  final Resume resume;
  final double scale;

  const ResumeCanvasWidget({
    super.key,
    required this.resume,
    this.scale = 1.0,
  });

  Color _getPrimaryColor() {
    try {
      final hex = resume.customization.colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getPrimaryColor();
    final isTwoColumn = resume.customization.layout == ResumeLayout.twoColumn;
    final isCompact = resume.customization.layout == ResumeLayout.compact;
    final p = resume.personalInfo;

    return Container(
      width: 360,
      constraints: const BoxConstraints(minHeight: 520),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(isCompact ? 14 : 20),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: resume.customization.fontFamily,
          color: const Color(0xFF0F172A),
          fontSize: isCompact ? 10 : 11,
          height: resume.customization.lineSpacing,
        ),
        child: isTwoColumn
            ? _buildTwoColumnLayout(primaryColor, p, isCompact)
            : _buildSingleColumnLayout(primaryColor, p, isCompact),
      ),
    );
  }

  Widget _buildSingleColumnLayout(
      Color primaryColor, PersonalInfo p, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Text(
          p.fullName.isNotEmpty ? p.fullName : 'Your Full Name',
          style: TextStyle(
            fontSize: resume.customization.headingSize + 2,
            fontWeight: FontWeight.w800,
            color: primaryColor,
            letterSpacing: -0.3,
          ),
        ),
        if (p.professionalTitle.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            p.professionalTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
        ],
        const SizedBox(height: 6),
        // Contact details row
        Wrap(
          spacing: 8,
          runSpacing: 3,
          children: [
            if (p.email.isNotEmpty) _contactItem(Icons.email, p.email),
            if (p.phone.isNotEmpty) _contactItem(Icons.phone, p.phone),
            if (p.location.isNotEmpty) _contactItem(Icons.location_on, p.location),
            if (p.linkedIn.isNotEmpty) _contactItem(Icons.link, p.linkedIn),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFE2E8F0), height: 1),
        const SizedBox(height: 10),

        // Summary
        if (resume.summary.isNotEmpty &&
            (resume.customization.sectionVisibility['Summary'] ?? true)) ...[
          _sectionTitle('PROFESSIONAL SUMMARY', primaryColor),
          const SizedBox(height: 4),
          Text(
            resume.summary,
            style: const TextStyle(color: Color(0xFF334155)),
          ),
          const SizedBox(height: 12),
        ],

        // Experience
        if (resume.experiences.isNotEmpty &&
            (resume.customization.sectionVisibility['Experience'] ?? true)) ...[
          _sectionTitle('WORK EXPERIENCE', primaryColor),
          const SizedBox(height: 6),
          ...resume.experiences.map((exp) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            exp.jobTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Text(
                          DateFormatter.formatRange(
                            exp.startDate,
                            exp.endDate,
                            isCurrent: exp.isCurrentlyWorking,
                          ),
                          style: const TextStyle(
                              fontSize: 9.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    Text(
                      exp.company,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.5,
                        color: primaryColor,
                      ),
                    ),
                    if (exp.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        exp.description,
                        style: const TextStyle(color: Color(0xFF334155)),
                      ),
                    ],
                    ...exp.achievements.map((a) => Padding(
                          padding: const EdgeInsets.only(top: 2, left: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  a,
                                  style: const TextStyle(
                                      color: Color(0xFF334155)),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              )),
          const SizedBox(height: 6),
        ],

        // Education
        if (resume.educations.isNotEmpty &&
            (resume.customization.sectionVisibility['Education'] ?? true)) ...[
          _sectionTitle('EDUCATION', primaryColor),
          const SizedBox(height: 6),
          ...resume.educations.map((edu) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edu.degree,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          edu.institution,
                          style: TextStyle(fontSize: 10, color: primaryColor),
                        ),
                      ],
                    ),
                    Text(
                      DateFormatter.formatRange(
                          edu.startDate, edu.graduationDate),
                      style: const TextStyle(
                          fontSize: 9.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 6),
        ],

        // Skills
        if (resume.skills.isNotEmpty &&
            (resume.customization.sectionVisibility['Skills'] ?? true)) ...[
          _sectionTitle('SKILLS', primaryColor),
          const SizedBox(height: 6),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: resume.skills
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${s.name} (${s.level.label})',
                        style: const TextStyle(
                            fontSize: 9, color: Color(0xFF1E293B)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
        ],

        // References
        if (resume.includeReferences) ...[
          _sectionTitle('REFERENCES', primaryColor),
          const SizedBox(height: 4),
          if (resume.references.isEmpty)
            const Text(
              'References available upon request.',
              style: TextStyle(
                  fontSize: 9.5,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF64748B)),
            )
          else
            ...resume.references.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${r.name} - ${r.jobTitle}, ${r.company} (${r.email})',
                    style: const TextStyle(
                        fontSize: 9.5, color: Color(0xFF334155)),
                  ),
                )),
        ],
      ],
    );
  }

  Widget _buildTwoColumnLayout(
      Color primaryColor, PersonalInfo p, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.fullName.isNotEmpty ? p.fullName : 'Your Full Name',
                    style: TextStyle(
                      fontSize: resume.customization.headingSize + 1,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  if (p.professionalTitle.isNotEmpty)
                    Text(
                      p.professionalTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (p.email.isNotEmpty) _contactItem(Icons.email, p.email),
                if (p.phone.isNotEmpty) _contactItem(Icons.phone, p.phone),
                if (p.location.isNotEmpty)
                  _contactItem(Icons.location_on, p.location),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Color(0xFFE2E8F0), height: 1),
        const SizedBox(height: 10),

        // Split
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Column (65%)
            Expanded(
              flex: 65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (resume.summary.isNotEmpty) ...[
                    _sectionTitle('SUMMARY', primaryColor),
                    const SizedBox(height: 4),
                    Text(resume.summary,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF334155))),
                    const SizedBox(height: 12),
                  ],
                  if (resume.experiences.isNotEmpty) ...[
                    _sectionTitle('EXPERIENCE', primaryColor),
                    const SizedBox(height: 6),
                    ...resume.experiences.map((exp) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exp.jobTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '${exp.company} • ${DateFormatter.formatRange(exp.startDate, exp.endDate, isCurrent: exp.isCurrentlyWorking)}',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (exp.description.isNotEmpty)
                                Text(
                                  exp.description,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Sidebar Column (35%)
            Expanded(
              flex: 35,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('EDUCATION', primaryColor),
                    const SizedBox(height: 4),
                    ...resume.educations.map((edu) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(edu.degree,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                              Text(edu.institution,
                                  style: const TextStyle(
                                      fontSize: 9, color: Color(0xFF64748B))),
                            ],
                          ),
                        )),
                    const SizedBox(height: 8),
                    _sectionTitle('SKILLS', primaryColor),
                    const SizedBox(height: 4),
                    ...resume.skills.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text('• ${s.name}',
                              style: const TextStyle(fontSize: 9.5)),
                        )),
                    if (resume.languages.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _sectionTitle('LANGUAGES', primaryColor),
                      const SizedBox(height: 4),
                      ...resume.languages.map((l) => Text(
                            '${l.language} (${l.proficiency.label})',
                            style: const TextStyle(fontSize: 9),
                          )),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contactItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: const Color(0xFF64748B)),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: color, width: 1.5)),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
