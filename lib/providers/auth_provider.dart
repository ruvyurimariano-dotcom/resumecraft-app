import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isPro;

  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isPro = false,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    bool? isPro,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPro: isPro ?? this.isPro,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  UserProfile? _currentUser = const UserProfile(
    name: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    isPro: false,
  );

  bool _isLoggedIn = true;
  bool _isGuest = false;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _isGuest;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final name = email.contains('@') ? email.split('@').first : 'User';
    _currentUser = UserProfile(
      name: name[0].toUpperCase() + name.substring(1),
      email: email,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    );
    _isLoggedIn = true;
    _isGuest = false;
    notifyListeners();
    return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    _currentUser = UserProfile(
      name: name,
      email: email,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    );
    _isLoggedIn = true;
    _isGuest = false;
    notifyListeners();
    return true;
  }

  void continueAsGuest() {
    _currentUser = const UserProfile(
      name: 'Guest User',
      email: 'guest@resumecraft.local',
      avatarUrl: '',
    );
    _isLoggedIn = true;
    _isGuest = true;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _isGuest = false;
    notifyListeners();
  }

  void upgradeToPro() {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isPro: true);
      notifyListeners();
    }
  }

  void updateProfileName(String newName) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: newName);
      notifyListeners();
    }
  }
}
