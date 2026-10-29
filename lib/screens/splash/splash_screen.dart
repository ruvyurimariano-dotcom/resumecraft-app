import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../services/storage_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/main_navigation_shell.dart';

/// Premium animated splash screen for ResumeCraft featuring staggered
/// entrances, glowing radar ripples, simulated ATS document lines,
/// real-time loading progress with dynamic status updates, and tap-to-skip.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;

  // Staggered Entrance Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotate;
  late final Animation<double> _badgeScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _loaderFade;

  // Pulse & Ripple
  late final Animation<double> _rippleRadius;
  late final Animation<double> _rippleAlpha;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // 1. Entrance animation (1500ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _logoRotate = Tween<double>(begin: -0.06, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    _badgeScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.45, 0.85, curve: Curves.elasticOut),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.60, 0.90, curve: Curves.easeIn),
      ),
    );

    _loaderFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.70, 1.0, curve: Curves.easeIn),
      ),
    );

    // 2. Continuous pulse & radar ripples (2200ms repeating)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _rippleRadius = Tween<double>(begin: 0.85, end: 1.55).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutQuad),
    );

    _rippleAlpha = Tween<double>(begin: 0.45, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOutQuad),
    );

    // 3. Smooth progress bar (2800ms)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _entranceController.forward();
    _progressController.forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateNext();
      }
    });
  }

  Future<void> _navigateNext() async {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    try {
      final storage = context.read<StorageService>();
      final onboardingDone = await storage.isOnboardingCompleted();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (context, anim, secAnim) =>
              onboardingDone ? const MainNavigationShell() : const OnboardingScreen(),
          transitionsBuilder: (context, anim, secAnim, child) {
            final curved = CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } catch (_) {
      // Fallback navigation
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  String _getStatusText(double progress) {
    if (progress < 0.30) {
      return 'Loading recruiter templates...';
    } else if (progress < 0.65) {
      return 'Calibrating ATS scanner...';
    } else if (progress < 0.90) {
      return 'Preparing workspace...';
    } else {
      return 'Ready!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateNext, // Tap anywhere to skip immediately
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F2B7A), // Deep Royal Navy
                Color(0xFF1D4ED8), // Primary Accent
                Color(0xFF2563EB), // Vibrant Blue
                Color(0xFF1E3A8A), // Executive Tone
              ],
              stops: [0.0, 0.4, 0.75, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Ambient floating glowing orbs in background
              _buildAmbientBackground(),

              // Foreground content
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(height: 24),

                              // Central Hero Group
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated Emblem with pulsing radar wave
                                  _buildCenterpiece(),
                                  const SizedBox(height: 32),

                                  // Staggered Title
                                  SlideTransition(
                                    position: _titleSlide,
                                    child: FadeTransition(
                                      opacity: _titleFade,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                AppStrings.appName,
                                                style: TextStyle(
                                                  fontSize: 34,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  letterSpacing: -0.6,
                                                  shadows: [
                                                    Shadow(
                                                      color: Color(0x66000000),
                                                      blurRadius: 16,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              AnimatedBuilder(
                                                animation: _pulseController,
                                                builder: (context, child) {
                                                  final scale = 0.9 + 0.2 * math.sin(_pulseController.value * 2 * math.pi);
                                                  return Transform.scale(
                                                    scale: scale,
                                                    child: const Text(
                                                      '✦',
                                                      style: TextStyle(
                                                        color: Color(0xFF60A5FA),
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),

                                          // AI & ATS Tagline Badge Pill
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.14),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.25),
                                                width: 1,
                                              ),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.auto_awesome,
                                                  size: 14,
                                                  color: Color(0xFF93C5FD),
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'AI-Powered • ATS-Optimized',
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // App Tagline
                                  FadeTransition(
                                    opacity: _taglineFade,
                                    child: Text(
                                      AppStrings.appTagline,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withValues(alpha: 0.88),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Bottom Section: Progress Bar, Status & Meta
                              FadeTransition(
                                opacity: _loaderFade,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Smooth Animated Progress Bar
                                      AnimatedBuilder(
                                        animation: _progressController,
                                        builder: (context, child) {
                                          final progress = _progressController.value;
                                          final percent = (progress * 100).toInt();
                                          return Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  height: 6,
                                                  width: 220,
                                                  color: Colors.white.withValues(alpha: 0.2),
                                                  child: FractionallySizedBox(
                                                    alignment: Alignment.centerLeft,
                                                    widthFactor: progress.clamp(0.02, 1.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [
                                                            Color(0xFF60A5FA),
                                                            Color(0xFF93C5FD),
                                                            Colors.white,
                                                          ],
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(0xFF60A5FA).withValues(alpha: 0.8),
                                                            blurRadius: 8,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: 220,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      _getStatusText(progress),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white.withValues(alpha: 0.85),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$percent%',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white.withValues(alpha: 0.95),
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'monospace',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 32),

                                      // Android Material 3 Indicator & Skip Hint
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.android_rounded,
                                            size: 16,
                                            color: Colors.white.withValues(alpha: 0.7),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Crafted for Android Material 3',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: Colors.white.withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Tap anywhere to skip',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withValues(alpha: 0.45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ambient glowing particle orbs
  Widget _buildAmbientBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final val = _pulseController.value;
        final dy1 = math.sin(val * 2 * math.pi) * 24;
        final dx2 = math.cos(val * 2 * math.pi) * 20;

        return Stack(
          children: [
            // Top-right glowing flare
            Positioned(
              top: -60 + dy1,
              right: -50,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF60A5FA).withValues(alpha: 0.22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF60A5FA).withValues(alpha: 0.35),
                      blurRadius: 90,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom-left glowing flare
            Positioned(
              bottom: -40,
              left: -50 + dx2,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                      blurRadius: 100,
                      spreadRadius: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Central animated emblem with radar ripple rings, 3D card tilt,
  /// miniature resume sheet graphics, and verified badge popup.
  Widget _buildCenterpiece() {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _pulseController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer radar ripple ring 1
            Transform.scale(
              scale: _rippleRadius.value,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: _rippleAlpha.value),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Secondary pulse ring
            Transform.scale(
              scale: (_rippleRadius.value * 0.85).clamp(0.8, 1.3),
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF93C5FD).withValues(alpha: (_rippleAlpha.value * 0.7).clamp(0.0, 1.0)),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            // Hero Emblem Container
            Transform.rotate(
              angle: _logoRotate.value,
              child: Transform.scale(
                scale: _logoScale.value,
                child: Container(
                  width: 106,
                  height: 106,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 32,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Miniature stylized ATS resume layout inside the icon
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Header with avatar bubble + title bar
                            Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryDark,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Simulated resume bullet lines with staggered widths
                            Container(
                              height: 3.5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF94A3B8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 3.5,
                              width: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFCBD5E1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 3.5,
                              width: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Floating Verified Check Badge
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: ScaleTransition(
                          scale: _badgeScale,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
