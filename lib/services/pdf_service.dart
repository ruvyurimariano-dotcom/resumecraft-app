import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/resume_model.dart';
import '../models/template_model.dart';
import '../core/utils/date_formatter.dart';

class PdfService {
  static Future<Uint8List> generateResumePdf({
    required Resume resume,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
    bool includePhoto = true,
    bool includeLinks = true,
    bool compress = false,
  }) async {
    final doc = pw.Document(
      compress: compress,
      title: '${resume.personalInfo.fullName} - Resume',
      author: resume.personalInfo.fullName,
    );

    final primaryPdfColor = _parsePdfColor(resume.customization.colorHex);
    final darkNeutral = PdfColor.fromHex('#0F172A');
    final mutedText = PdfColor.fromHex('#475569');
    final dividerColor = PdfColor.fromHex('#E2E8F0');

    // Font family definition
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontMedium = await PdfGoogleFonts.robotoMedium();

    doc.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
          fontFallback: [fontMedium],
        ),
        build: (pw.Context context) {
          final isTwoColumn = resume.customization.layout == ResumeLayout.twoColumn;
          if (isTwoColumn) {
            return _buildTwoColumnLayout(
              resume: resume,
              primaryColor: primaryPdfColor,
              darkNeutral: darkNeutral,
              mutedText: mutedText,
              dividerColor: dividerColor,
            );
          } else {
            return _buildSingleColumnLayout(
              resume: resume,
              primaryColor: primaryPdfColor,
              darkNeutral: darkNeutral,
              mutedText: mutedText,
              dividerColor: dividerColor,
            );
          }
        },
      ),
    );

    return doc.save();
  }

  static List<pw.Widget> _buildSingleColumnLayout({
    required Resume resume,
    required PdfColor primaryColor,
    required PdfColor darkNeutral,
    required PdfColor mutedText,
    required PdfColor dividerColor,
  }) {
    final p = resume.personalInfo;
    return [
      // Header
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            p.fullName.isNotEmpty ? p.fullName : 'Your Name',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
          if (p.professionalTitle.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              p.professionalTitle,
              style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: darkNeutral,
              ),
            ),
          ],
          pw.SizedBox(height: 6),
          // Contact info line
          pw.Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (p.email.isNotEmpty) _contactItem(p.email, mutedText),
              if (p.phone.isNotEmpty) _contactItem(p.phone, mutedText),
              if (p.location.isNotEmpty) _contactItem(p.location, mutedText),
              if (p.linkedIn.isNotEmpty) _contactItem(p.linkedIn, mutedText),
              if (p.website.isNotEmpty) _contactItem(p.website, mutedText),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Divider(color: dividerColor, thickness: 1),
        ],
      ),

      // Summary
      if (resume.summary.isNotEmpty &&
          (resume.customization.sectionVisibility['Summary'] ?? true)) ...[
        pw.SizedBox(height: 12),
        _sectionTitle('PROFESSIONAL SUMMARY', primaryColor),
        pw.SizedBox(height: 5),
        pw.Text(
          resume.summary,
          style: pw.TextStyle(fontSize: 10, color: darkNeutral, lineSpacing: 1.3),
        ),
      ],

      // Experience
      if (resume.experiences.isNotEmpty &&
          (resume.customization.sectionVisibility['Experience'] ?? true)) ...[
        pw.SizedBox(height: 14),
        _sectionTitle('WORK EXPERIENCE', primaryColor),
        pw.SizedBox(height: 6),
        ...resume.experiences.map((exp) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        exp.jobTitle,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: darkNeutral,
                        ),
                      ),
                      pw.Text(
                        DateFormatter.formatRange(
                          exp.startDate,
                          exp.endDate,
                          isCurrent: exp.isCurrentlyWorking,
                        ),
                        style: pw.TextStyle(fontSize: 9.5, color: mutedText),
                      ),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        exp.company,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      if (exp.location.isNotEmpty)
                        pw.Text(
                          exp.location,
                          style: pw.TextStyle(fontSize: 9.5, color: mutedText),
                        ),
                    ],
                  ),
                  if (exp.description.isNotEmpty) ...[
                    pw.SizedBox(height: 3),
                    pw.Text(
                      exp.description,
                      style: pw.TextStyle(fontSize: 9.5, color: darkNeutral),
                    ),
                  ],
                  ...exp.achievements.map((ach) => pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2, left: 8),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('• ',
                                style: pw.TextStyle(
                                    fontSize: 9.5, color: primaryColor)),
                            pw.Expanded(
                              child: pw.Text(
                                ach,
                                style: pw.TextStyle(
                                    fontSize: 9.5, color: darkNeutral),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )),
      ],

      // Education
      if (resume.educations.isNotEmpty &&
          (resume.customization.sectionVisibility['Education'] ?? true)) ...[
        pw.SizedBox(height: 12),
        _sectionTitle('EDUCATION', primaryColor),
        pw.SizedBox(height: 6),
        ...resume.educations.map((edu) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        edu.degree,
                        style: pw.TextStyle(
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                          color: darkNeutral,
                        ),
                      ),
                      pw.Text(
                        edu.institution,
                        style: pw.TextStyle(fontSize: 9.5, color: primaryColor),
                      ),
                      if (edu.gpa.isNotEmpty)
                        pw.Text('GPA: ${edu.gpa}',
                            style: pw.TextStyle(fontSize: 9, color: mutedText)),
                    ],
                  ),
                  pw.Text(
                    DateFormatter.formatRange(edu.startDate, edu.graduationDate),
                    style: pw.TextStyle(fontSize: 9.5, color: mutedText),
                  ),
                ],
              ),
            )),
      ],

      // Skills
      if (resume.skills.isNotEmpty &&
          (resume.customization.sectionVisibility['Skills'] ?? true)) ...[
        pw.SizedBox(height: 12),
        _sectionTitle('SKILLS', primaryColor),
        pw.SizedBox(height: 6),
        pw.Wrap(
          spacing: 6,
          runSpacing: 4,
          children: resume.skills
              .map((s) => pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F1F5F9'),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      '${s.name} (${s.level.label})',
                      style: pw.TextStyle(fontSize: 8.5, color: darkNeutral),
                    ),
                  ))
              .toList(),
        ),
      ],

      // Projects
      if (resume.projects.isNotEmpty &&
          (resume.customization.sectionVisibility['Projects'] ?? true)) ...[
        pw.SizedBox(height: 12),
        _sectionTitle('PROJECTS', primaryColor),
        pw.SizedBox(height: 6),
        ...resume.projects.map((proj) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    proj.projectName,
                    style: pw.TextStyle(
                      fontSize: 10.5,
                      fontWeight: pw.FontWeight.bold,
                      color: darkNeutral,
                    ),
                  ),
                  pw.Text(
                    proj.description,
                    style: pw.TextStyle(fontSize: 9.5, color: darkNeutral),
                  ),
                  if (proj.technologies.isNotEmpty)
                    pw.Text(
                      'Tech: ${proj.technologies.join(', ')}',
                      style: pw.TextStyle(fontSize: 8.5, color: mutedText),
                    ),
                ],
              ),
            )),
      ],
    ];
  }

  static List<pw.Widget> _buildTwoColumnLayout({
    required Resume resume,
    required PdfColor primaryColor,
    required PdfColor darkNeutral,
    required PdfColor mutedText,
    required PdfColor dividerColor,
  }) {
    final p = resume.personalInfo;
    return [
      // Top Header
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  p.fullName.isNotEmpty ? p.fullName : 'Your Name',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                if (p.professionalTitle.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    p.professionalTitle,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: darkNeutral,
                    ),
                  ),
                ],
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if (p.email.isNotEmpty) _contactItem(p.email, mutedText),
              if (p.phone.isNotEmpty) _contactItem(p.phone, mutedText),
              if (p.location.isNotEmpty) _contactItem(p.location, mutedText),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Divider(color: dividerColor, thickness: 1),
      pw.SizedBox(height: 10),

      // Two Column Split
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Main Body (65% width)
          pw.Expanded(
            flex: 65,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (resume.summary.isNotEmpty) ...[
                  _sectionTitle('SUMMARY', primaryColor),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    resume.summary,
                    style: pw.TextStyle(fontSize: 9.5, color: darkNeutral),
                  ),
                  pw.SizedBox(height: 12),
                ],
                if (resume.experiences.isNotEmpty) ...[
                  _sectionTitle('EXPERIENCE', primaryColor),
                  pw.SizedBox(height: 6),
                  ...resume.experiences.map((exp) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  exp.jobTitle,
                                  style: pw.TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: pw.FontWeight.bold,
                                    color: darkNeutral,
                                  ),
                                ),
                                pw.Text(
                                  DateFormatter.formatRange(
                                    exp.startDate,
                                    exp.endDate,
                                    isCurrent: exp.isCurrentlyWorking,
                                  ),
                                  style: pw.TextStyle(
                                      fontSize: 9, color: mutedText),
                                ),
                              ],
                            ),
                            pw.Text(
                              exp.company,
                              style: pw.TextStyle(
                                  fontSize: 9.5,
                                  color: primaryColor,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            if (exp.description.isNotEmpty)
                              pw.Text(
                                exp.description,
                                style: pw.TextStyle(
                                    fontSize: 9, color: darkNeutral),
                              ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
          pw.SizedBox(width: 16),
          // Sidebar (35% width)
          pw.Expanded(
            flex: 35,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8FAFC'),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle('EDUCATION', primaryColor),
                  pw.SizedBox(height: 4),
                  ...resume.educations.map((edu) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 6),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              edu.degree,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                fontWeight: pw.FontWeight.bold,
                                color: darkNeutral,
                              ),
                            ),
                            pw.Text(
                              edu.institution,
                              style: pw.TextStyle(
                                  fontSize: 8.5, color: mutedText),
                            ),
                          ],
                        ),
                      )),
                  pw.SizedBox(height: 10),
                  _sectionTitle('SKILLS', primaryColor),
                  pw.SizedBox(height: 4),
                  ...resume.skills.map((s) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 3),
                        child: pw.Text(
                          '• ${s.name}',
                          style: pw.TextStyle(fontSize: 9, color: darkNeutral),
                        ),
                      )),
                  if (resume.languages.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    _sectionTitle('LANGUAGES', primaryColor),
                    pw.SizedBox(height: 4),
                    ...resume.languages.map((l) => pw.Text(
                          '${l.language} (${l.proficiency.label})',
                          style: pw.TextStyle(fontSize: 8.5, color: darkNeutral),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  static pw.Widget _contactItem(String text, PdfColor color) {
    return pw.Text(
      text,
      style: pw.TextStyle(fontSize: 9, color: color),
    );
  }

  static pw.Widget _sectionTitle(String title, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 2),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: color, width: 1.5)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  static PdfColor _parsePdfColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return PdfColor.fromHex('#$clean');
    } catch (_) {
      return PdfColor.fromHex('#2563EB');
    }
  }
}
