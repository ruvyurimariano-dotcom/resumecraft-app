class AtsCategoryScore {
  final String category;
  final int score;
  final int maxScore;
  final String status;
  final String feedback;

  const AtsCategoryScore({
    required this.category,
    required this.score,
    required this.maxScore,
    required this.status,
    required this.feedback,
  });

  double get ratio => (score / maxScore).clamp(0.0, 1.0);
}

class AtsRecommendation {
  final String title;
  final String description;
  final String category;
  final bool isHighPriority;
  final String? suggestedAction;

  const AtsRecommendation({
    required this.title,
    required this.description,
    required this.category,
    this.isHighPriority = false,
    this.suggestedAction,
  });
}

class AtsAnalysisResult {
  final int overallScore; // 0 to 100
  final List<AtsCategoryScore> categories;
  final List<AtsRecommendation> recommendations;
  final List<String> identifiedKeywords;
  final List<String> missingKeywords;
  final bool isAtsFriendly;

  const AtsAnalysisResult({
    required this.overallScore,
    required this.categories,
    required this.recommendations,
    required this.identifiedKeywords,
    required this.missingKeywords,
    required this.isAtsFriendly,
  });
}

class JobMatchResult {
  final int matchPercentage;
  final List<String> matchedKeywords;
  final List<String> missingKeywords;
  final List<String> recommendedSkills;
  final List<String> improvements;

  const JobMatchResult({
    required this.matchPercentage,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.recommendedSkills,
    required this.improvements,
  });
}
