import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/resume_model.dart';
import 'pdf_service.dart';

class ShareService {
  static Future<void> shareResumePdf({
    required BuildContext context,
    required Resume resume,
  }) async {
    try {
      final pdfBytes = await PdfService.generateResumePdf(resume: resume);
      final filename = '${resume.personalInfo.fullName.replaceAll(' ', '_')}_Resume.pdf';
      await Printing.sharePdf(bytes: pdfBytes, filename: filename);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sharing failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<void> shareResumeText({
    required BuildContext context,
    required Resume resume,
  }) async {
    final buffer = StringBuffer();
    final p = resume.personalInfo;
    buffer.writeln('${p.fullName.toUpperCase()}');
    buffer.writeln('${p.professionalTitle}');
    buffer.writeln('${p.email} | ${p.phone} | ${p.location}');
    if (p.linkedIn.isNotEmpty) buffer.writeln('LinkedIn: ${p.linkedIn}');
    buffer.writeln('\n--- SUMMARY ---');
    buffer.writeln(resume.summary);

    if (resume.experiences.isNotEmpty) {
      buffer.writeln('\n--- EXPERIENCE ---');
      for (final exp in resume.experiences) {
        buffer.writeln('${exp.jobTitle} - ${exp.company}');
        buffer.writeln(exp.description);
        for (final a in exp.achievements) {
          buffer.writeln('• $a');
        }
      }
    }

    if (resume.educations.isNotEmpty) {
      buffer.writeln('\n--- EDUCATION ---');
      for (final edu in resume.educations) {
        buffer.writeln('${edu.degree}, ${edu.institution}');
      }
    }

    if (resume.skills.isNotEmpty) {
      buffer.writeln('\n--- SKILLS ---');
      buffer.writeln(resume.skills.map((s) => s.name).join(', '));
    }

    await Share.share(
      buffer.toString(),
      subject: '${p.fullName} - Resume',
    );
  }
}
