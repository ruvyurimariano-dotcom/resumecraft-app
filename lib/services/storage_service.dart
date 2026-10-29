import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume_model.dart';
import '../models/experience_model.dart';
import '../models/education_model.dart';
import '../models/skill_model.dart';
import '../models/project_model.dart';

class StorageService {
  static const String _resumesKey = 'resumecraft_saved_resumes';
  static const String _onboardingCompleteKey = 'resumecraft_onboarding_done';
  static const String _themeModeKey = 'resumecraft_theme_mode';
  static const String _userProfileKey = 'resumecraft_user_profile';

  Future<List<Resume>> getAllResumes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_resumesKey);
    if (jsonString == null || jsonString.isEmpty) {
      // Seed an initial sample resume for first-time onboarding demonstration
      final sample = _createSampleResume();
      await saveResume(sample);
      return [sample];
    }
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => Resume.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Resume?> getResumeById(String id) async {
    final all = await getAllResumes();
    try {
      return all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveResume(Resume resume) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAllResumes();
    final index = all.indexWhere((r) => r.id == resume.id);

    final updatedResume = resume.copyWith(updatedAt: DateTime.now());

    if (index >= 0) {
      all[index] = updatedResume;
    } else {
      all.insert(0, updatedResume);
    }

    final encoded = jsonEncode(all.map((e) => e.toJson()).toList());
    return await prefs.setString(_resumesKey, encoded);
  }

  Future<bool> deleteResume(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final all = await getAllResumes();
    all.removeWhere((r) => r.id == id);
    final encoded = jsonEncode(all.map((e) => e.toJson()).toList());
    return await prefs.setString(_resumesKey, encoded);
  }

  Future<Resume?> duplicateResume(String id) async {
    final original = await getResumeById(id);
    if (original == null) return null;
    final duplicated = original.copyWith(
      id: null, // generate new id
      title: '${original.title} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveResume(duplicated);
    return duplicated;
  }

  Future<bool> renameResume(String id, String newTitle) async {
    final original = await getResumeById(id);
    if (original == null) return false;
    final updated = original.copyWith(title: newTitle);
    return await saveResume(updated);
  }

  Future<bool> deleteAllResumes() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_resumesKey);
  }

  // Onboarding status
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, completed);
  }

  // Theme settings
  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  // Backup & Restore
  Future<String> exportBackupJson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_resumesKey) ?? '[]';
  }

  Future<bool> importBackupJson(String jsonString) async {
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      // Validate parse
      decoded.map((e) => Resume.fromJson(e as Map<String, dynamic>)).toList();
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_resumesKey, jsonString);
    } catch (_) {
      return false;
    }
  }

  static Resume _createSampleResume() {
    return Resume(
      title: 'Alex Morgan - Software Engineer',
      resumeType: 'Professional Resume',
      personalInfo: PersonalInfo(
        fullName: 'Alex Morgan',
        professionalTitle: 'Senior Full Stack Engineer',
        email: 'alex.morgan@example.com',
        phone: '+1 (555) 234-5678',
        location: 'San Francisco, CA',
        website: 'https://alexmorgan.dev',
        linkedIn: 'https://linkedin.com/in/alexmorgan',
        portfolio: 'https://github.com/alexmorgan',
      ),
      summary:
          'Passionate and results-driven Software Engineer with 5+ years of experience crafting high-performance mobile and cloud architectures. Proven expertise in Flutter, Dart, TypeScript, and microservices with a strong record of optimizing app load times by 40% and leading agile cross-functional teams.',
      experiences: [
        WorkExperience(
          jobTitle: 'Senior Mobile Engineer',
          company: 'TechFlow Systems',
          location: 'San Francisco, CA',
          startDate: DateTime(2021, 3),
          isCurrentlyWorking: true,
          description:
              'Spearheaded the redesign and mobile rewrite of the flagship fintech client application using Flutter and clean architecture.',
          achievements: [
            'Architected state management reducing app memory footprint by 32% and crash rate to under 0.01%.',
            'Mentored 6 junior engineers and implemented automated CI/CD pipeline reducing build release cycle from 3 days to 45 minutes.',
          ],
        ),
        WorkExperience(
          jobTitle: 'Software Engineer',
          company: 'Apex Innovations',
          location: 'Austin, TX',
          startDate: DateTime(2019, 1),
          endDate: DateTime(2021, 2),
          description:
              'Developed customer-facing APIs and progressive web features serving 250,000+ daily active users.',
          achievements: [
            'Integrated real-time websocket synchronization resulting in a 45% increase in user session engagement.',
            'Collaborated with UX team to achieve 98% accessibility compliance score.',
          ],
        ),
      ],
      educations: [
        Education(
          degree: 'B.S. in Computer Science',
          institution: 'University of California, Berkeley',
          location: 'Berkeley, CA',
          startDate: DateTime(2015, 8),
          graduationDate: DateTime(2019, 5),
          gpa: '3.85',
          description: 'Dean’s Honors List, President of Mobile App Developers Club.',
        ),
      ],
      skills: [
        Skill(name: 'Flutter & Dart', level: SkillLevel.expert, category: 'Mobile'),
        Skill(name: 'TypeScript & Node.js', level: SkillLevel.advanced, category: 'Backend'),
        Skill(name: 'REST & GraphQL APIs', level: SkillLevel.expert, category: 'Architecture'),
        Skill(name: 'CI/CD & Docker', level: SkillLevel.intermediate, category: 'DevOps'),
        Skill(name: 'Agile Leadership', level: SkillLevel.advanced, category: 'Soft Skills'),
      ],
      projects: [
        Project(
          projectName: 'Pulse Cloud Monitor',
          role: 'Lead Developer',
          description:
              'Cross-platform telemetry app monitoring distributed server health metrics in real-time.',
          technologies: ['Flutter', 'Go', 'Prometheus'],
          projectUrl: 'https://github.com/alexmorgan/pulse-monitor',
        ),
      ],
    );
  }
}
