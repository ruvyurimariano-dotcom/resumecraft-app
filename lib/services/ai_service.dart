class AiService {
  /// Simulates smart AI generation with immediate offline processing and contextual relevance
  static Future<String> generateSummary({
    required String title,
    List<String> skills = const [],
    int yearsExp = 4,
  }) async {
    await Future.delayed(const Duration(milliseconds: 650));
    final titleClean = title.trim().isEmpty ? 'Professional' : title.trim();
    final topSkills = skills.take(3).join(', ');
    final skillsClause =
        topSkills.isNotEmpty ? ' with proven proficiency in $topSkills' : '';

    return 'Accomplished and growth-focused $titleClean with $yearsExp+ years of success delivering impactful initiatives$skillsClause. Recognized for combining analytical rigor with strong cross-functional collaboration to optimize workflows, elevate product quality, and drive strategic organizational goals.';
  }

  static Future<String> rewriteSummary({
    required String existingSummary,
    required String style, // 'improve', 'professional', 'shorten', 'ats'
  }) async {
    await Future.delayed(const Duration(milliseconds: 550));
    final trimmed = existingSummary.trim();
    if (trimmed.isEmpty) {
      return 'Results-oriented specialist with demonstrable track record in delivering high-impact solutions, streamlining operational workflows, and spearheading cross-functional collaboration.';
    }

    switch (style.toLowerCase()) {
      case 'shorten':
        final sentences = trimmed.split('. ');
        if (sentences.length > 2) {
          return '${sentences.take(2).join('. ')}.';
        }
        return '$trimmed (Concise)';

      case 'ats':
        return '$trimmed Specializes in end-to-end execution, Agile methodologies, stakeholder communication, and performance optimization with quantifiable ROI metrics.';

      case 'professional':
        return 'Executive-level professional with comprehensive background executing critical business objectives. Proven capability to align technological solutions with overarching corporate vision while mentoring high-performing teams.';

      case 'improve':
      default:
        return '$trimmed Consistently exceeds performance targets by leveraging data-driven insights, modern industry best practices, and proactive problem resolution.';
    }
  }

  static Future<List<String>> generateAchievements({
    required String jobTitle,
    required String company,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final title = jobTitle.trim().isEmpty ? 'team member' : jobTitle.trim();
    final comp = company.trim().isEmpty ? 'the organization' : company.trim();

    return [
      'Spearheaded core feature roadmap at $comp as $title, reducing delivery latency by 28% while maintaining 99.9% operational reliability.',
      'Authored automated testing scripts and standardized code reviews, increasing test coverage by 35% and cutting regression defects by half.',
      'Partnered with cross-department stakeholders to architect scalable solutions, resulting in an estimated \$140K annual infrastructure cost savings.',
    ];
  }

  static Future<List<String>> suggestSkillsForTitle(String title) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lower = title.toLowerCase();

    if (lower.contains('flutter') || lower.contains('mobile') || lower.contains('android')) {
      return [
        'Flutter & Dart',
        'State Management (Provider/Bloc)',
        'RESTful APIs & GraphQL',
        'Git & CI/CD Pipelines',
        'Material 3 & Cupertino',
        'Unit & Integration Testing',
        'Firebase Integration',
        'App Store & Play Store Deployment',
      ];
    } else if (lower.contains('data') || lower.contains('python') || lower.contains('analyst')) {
      return [
        'Python & Pandas',
        'SQL & Relational Databases',
        'Data Visualization (Tableau/PowerBI)',
        'Statistical Modeling',
        'Machine Learning Fundamentals',
        'ETL Pipeline Design',
        'A/B Testing & Hypothesis Analysis',
      ];
    } else if (lower.contains('product') || lower.contains('manager') || lower.contains('lead')) {
      return [
        'Agile & Scrum Methodologies',
        'Product Roadmap Strategy',
        'User Research & Prototyping',
        'Data-Driven Decision Making',
        'Cross-Functional Leadership',
        'Go-to-Market Execution',
        'KPI & OKR Management',
      ];
    } else {
      return [
        'Strategic Planning',
        'Cross-Functional Collaboration',
        'Process Optimization',
        'Project Management',
        'Stakeholder Communication',
        'Data Analysis',
        'Problem Solving & Innovation',
      ];
    }
  }
}
