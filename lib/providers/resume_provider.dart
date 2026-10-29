import 'dart:async';
import 'package:flutter/material.dart';
import '../models/resume_model.dart';
import '../models/experience_model.dart';
import '../models/education_model.dart';
import '../models/skill_model.dart';
import '../models/project_model.dart';
import '../models/certification_model.dart';
import '../models/language_model.dart';
import '../models/reference_model.dart';
import '../models/template_model.dart';
import '../services/storage_service.dart';
import '../core/constants/app_strings.dart';

class ResumeProvider extends ChangeNotifier {
  final StorageService _storageService;
  Resume _activeResume;
  int _currentStep = 0;
  bool _isSaving = false;
  String _saveStatus = AppStrings.savedJustNow;
  Timer? _debounceTimer;

  ResumeProvider(this._storageService, Resume initialResume)
      : _activeResume = initialResume;

  Resume get activeResume => _activeResume;
  int get currentStep => _currentStep;
  bool get isSaving => _isSaving;
  String get saveStatus => _saveStatus;

  void setActiveResume(Resume resume) {
    _activeResume = resume;
    _currentStep = 0;
    _saveStatus = AppStrings.savedJustNow;
    notifyListeners();
  }

  void setStep(int step) {
    if (step >= 0 && step <= 9) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < 9) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void _triggerAutosave() {
    _isSaving = true;
    _saveStatus = AppStrings.saving;
    notifyListeners();

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      try {
        await _storageService.saveResume(_activeResume);
        _isSaving = false;
        _saveStatus = AppStrings.savedJustNow;
      } catch (e) {
        _isSaving = false;
        _saveStatus = AppStrings.saveFailed;
      }
      notifyListeners();
    });
  }

  Future<void> forceSave() async {
    _debounceTimer?.cancel();
    _isSaving = true;
    _saveStatus = AppStrings.saving;
    notifyListeners();

    try {
      await _storageService.saveResume(_activeResume);
      _isSaving = false;
      _saveStatus = AppStrings.savedJustNow;
    } catch (_) {
      _isSaving = false;
      _saveStatus = AppStrings.saveFailed;
    }
    notifyListeners();
  }

  // Personal Info
  void updatePersonalInfo(PersonalInfo info) {
    _activeResume = _activeResume.copyWith(personalInfo: info);
    _triggerAutosave();
  }

  // Summary
  void updateSummary(String summary) {
    _activeResume = _activeResume.copyWith(summary: summary);
    _triggerAutosave();
  }

  // Experience
  void addExperience(WorkExperience exp) {
    final list = List<WorkExperience>.from(_activeResume.experiences)..add(exp);
    _activeResume = _activeResume.copyWith(experiences: list);
    _triggerAutosave();
  }

  void updateExperience(int index, WorkExperience exp) {
    if (index >= 0 && index < _activeResume.experiences.length) {
      final list = List<WorkExperience>.from(_activeResume.experiences);
      list[index] = exp;
      _activeResume = _activeResume.copyWith(experiences: list);
      _triggerAutosave();
    }
  }

  void removeExperience(int index) {
    if (index >= 0 && index < _activeResume.experiences.length) {
      final list = List<WorkExperience>.from(_activeResume.experiences)..removeAt(index);
      _activeResume = _activeResume.copyWith(experiences: list);
      _triggerAutosave();
    }
  }

  void reorderExperience(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final list = List<WorkExperience>.from(_activeResume.experiences);
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    _activeResume = _activeResume.copyWith(experiences: list);
    _triggerAutosave();
  }

  // Education
  void addEducation(Education edu) {
    final list = List<Education>.from(_activeResume.educations)..add(edu);
    _activeResume = _activeResume.copyWith(educations: list);
    _triggerAutosave();
  }

  void updateEducation(int index, Education edu) {
    if (index >= 0 && index < _activeResume.educations.length) {
      final list = List<Education>.from(_activeResume.educations);
      list[index] = edu;
      _activeResume = _activeResume.copyWith(educations: list);
      _triggerAutosave();
    }
  }

  void removeEducation(int index) {
    if (index >= 0 && index < _activeResume.educations.length) {
      final list = List<Education>.from(_activeResume.educations)..removeAt(index);
      _activeResume = _activeResume.copyWith(educations: list);
      _triggerAutosave();
    }
  }

  // Skills
  void addSkill(Skill skill) {
    final list = List<Skill>.from(_activeResume.skills)..add(skill);
    _activeResume = _activeResume.copyWith(skills: list);
    _triggerAutosave();
  }

  void updateSkill(int index, Skill skill) {
    if (index >= 0 && index < _activeResume.skills.length) {
      final list = List<Skill>.from(_activeResume.skills);
      list[index] = skill;
      _activeResume = _activeResume.copyWith(skills: list);
      _triggerAutosave();
    }
  }

  void removeSkill(int index) {
    if (index >= 0 && index < _activeResume.skills.length) {
      final list = List<Skill>.from(_activeResume.skills)..removeAt(index);
      _activeResume = _activeResume.copyWith(skills: list);
      _triggerAutosave();
    }
  }

  // Projects
  void addProject(Project project) {
    final list = List<Project>.from(_activeResume.projects)..add(project);
    _activeResume = _activeResume.copyWith(projects: list);
    _triggerAutosave();
  }

  void updateProject(int index, Project project) {
    if (index >= 0 && index < _activeResume.projects.length) {
      final list = List<Project>.from(_activeResume.projects);
      list[index] = project;
      _activeResume = _activeResume.copyWith(projects: list);
      _triggerAutosave();
    }
  }

  void removeProject(int index) {
    if (index >= 0 && index < _activeResume.projects.length) {
      final list = List<Project>.from(_activeResume.projects)..removeAt(index);
      _activeResume = _activeResume.copyWith(projects: list);
      _triggerAutosave();
    }
  }

  // Certifications
  void addCertification(Certification cert) {
    final list = List<Certification>.from(_activeResume.certifications)..add(cert);
    _activeResume = _activeResume.copyWith(certifications: list);
    _triggerAutosave();
  }

  void removeCertification(int index) {
    if (index >= 0 && index < _activeResume.certifications.length) {
      final list = List<Certification>.from(_activeResume.certifications)..removeAt(index);
      _activeResume = _activeResume.copyWith(certifications: list);
      _triggerAutosave();
    }
  }

  // Languages
  void addLanguage(Language lang) {
    final list = List<Language>.from(_activeResume.languages)..add(lang);
    _activeResume = _activeResume.copyWith(languages: list);
    _triggerAutosave();
  }

  void removeLanguage(int index) {
    if (index >= 0 && index < _activeResume.languages.length) {
      final list = List<Language>.from(_activeResume.languages)..removeAt(index);
      _activeResume = _activeResume.copyWith(languages: list);
      _triggerAutosave();
    }
  }

  // References
  void addReference(Reference ref) {
    final list = List<Reference>.from(_activeResume.references)..add(ref);
    _activeResume = _activeResume.copyWith(references: list);
    _triggerAutosave();
  }

  void removeReference(int index) {
    if (index >= 0 && index < _activeResume.references.length) {
      final list = List<Reference>.from(_activeResume.references)..removeAt(index);
      _activeResume = _activeResume.copyWith(references: list);
      _triggerAutosave();
    }
  }

  void toggleIncludeReferences(bool val) {
    _activeResume = _activeResume.copyWith(includeReferences: val);
    _triggerAutosave();
  }

  // Customization
  void updateCustomization(CustomizationConfig config) {
    _activeResume = _activeResume.copyWith(customization: config);
    _triggerAutosave();
  }

  void setTemplateId(String templateId) {
    _activeResume = _activeResume.copyWith(
      customization: _activeResume.customization.copyWith(templateId: templateId),
    );
    _triggerAutosave();
  }

  void setColorHex(String hex) {
    _activeResume = _activeResume.copyWith(
      customization: _activeResume.customization.copyWith(colorHex: hex),
    );
    _triggerAutosave();
  }

  void setLayout(ResumeLayout layout) {
    _activeResume = _activeResume.copyWith(
      customization: _activeResume.customization.copyWith(layout: layout),
    );
    _triggerAutosave();
  }

  void toggleSectionVisibility(String sectionName, bool isVisible) {
    final map = Map<String, bool>.from(_activeResume.customization.sectionVisibility);
    map[sectionName] = isVisible;
    _activeResume = _activeResume.copyWith(
      customization: _activeResume.customization.copyWith(sectionVisibility: map),
    );
    _triggerAutosave();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
