import 'package:flutter/material.dart';
import '../models/resume_model.dart';
import '../services/storage_service.dart';

class ResumeListProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<Resume> _resumes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  ResumeListProvider(this._storageService) {
    loadResumes();
  }

  List<Resume> get resumes {
    if (_searchQuery.trim().isEmpty) return _resumes;
    final query = _searchQuery.toLowerCase();
    return _resumes
        .where((r) =>
            r.title.toLowerCase().contains(query) ||
            r.personalInfo.fullName.toLowerCase().contains(query) ||
            r.personalInfo.professionalTitle.toLowerCase().contains(query))
        .toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Resume? get mostRecentResume {
    if (_resumes.isEmpty) return null;
    final sorted = List<Resume>.from(_resumes)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted.first;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadResumes() async {
    _isLoading = true;
    notifyListeners();
    _resumes = await _storageService.getAllResumes();
    _resumes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _isLoading = false;
    notifyListeners();
  }

  Future<Resume> createNewResume({
    required String title,
    required String resumeType,
    String templateId = 'modern_pro',
  }) async {
    final newResume = Resume(
      title: title,
      resumeType: resumeType,
      customization: _resumes.isNotEmpty
          ? _resumes.first.customization.copyWith(templateId: templateId)
          : null,
    );
    await _storageService.saveResume(newResume);
    await loadResumes();
    return newResume;
  }

  Future<Resume?> duplicateResume(String id) async {
    final duplicated = await _storageService.duplicateResume(id);
    if (duplicated != null) {
      await loadResumes();
    }
    return duplicated;
  }

  Future<bool> renameResume(String id, String newTitle) async {
    final success = await _storageService.renameResume(id, newTitle);
    if (success) {
      await loadResumes();
    }
    return success;
  }

  Future<bool> deleteResume(String id) async {
    final success = await _storageService.deleteResume(id);
    if (success) {
      await loadResumes();
    }
    return success;
  }
}
