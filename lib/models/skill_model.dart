import 'package:uuid/uuid.dart';

enum SkillLevel {
  beginner('Beginner', 0.25),
  intermediate('Intermediate', 0.50),
  advanced('Advanced', 0.75),
  expert('Expert', 1.0);

  final String label;
  final double percentage;
  const SkillLevel(this.label, this.percentage);
}

class Skill {
  final String id;
  final String name;
  final SkillLevel level;
  final String category;

  Skill({
    String? id,
    required this.name,
    this.level = SkillLevel.advanced,
    this.category = 'General',
  }) : id = id ?? const Uuid().v4();

  Skill copyWith({
    String? id,
    String? name,
    SkillLevel? level,
    String? category,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level.name,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      level: SkillLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => SkillLevel.advanced,
      ),
      category: json['category'] as String? ?? 'General',
    );
  }
}
