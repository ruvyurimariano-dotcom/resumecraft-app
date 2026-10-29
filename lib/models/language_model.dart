import 'package:uuid/uuid.dart';

enum LanguageProficiency {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced'),
  fluent('Fluent'),
  native('Native');

  final String label;
  const LanguageProficiency(this.label);
}

class Language {
  final String id;
  final String language;
  final LanguageProficiency proficiency;

  Language({
    String? id,
    required this.language,
    this.proficiency = LanguageProficiency.fluent,
  }) : id = id ?? const Uuid().v4();

  Language copyWith({
    String? id,
    String? language,
    LanguageProficiency? proficiency,
  }) {
    return Language(
      id: id ?? this.id,
      language: language ?? this.language,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'proficiency': proficiency.name,
    };
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] as String?,
      language: json['language'] as String? ?? '',
      proficiency: LanguageProficiency.values.firstWhere(
        (e) => e.name == json['proficiency'],
        orElse: () => LanguageProficiency.fluent,
      ),
    );
  }
}
