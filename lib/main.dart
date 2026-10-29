import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'models/resume_model.dart';
import 'providers/auth_provider.dart';
import 'providers/resume_list_provider.dart';
import 'providers/resume_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Android system overlay styles (Edge-to-edge status & navigation bars)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final storageService = StorageService();
  final resumes = await storageService.getAllResumes();
  final initialResume = resumes.isNotEmpty ? resumes.first : Resume();

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<ResumeListProvider>(
          create: (_) => ResumeListProvider(storageService),
        ),
        ChangeNotifierProvider<ResumeProvider>(
          create: (_) => ResumeProvider(storageService, initialResume),
        ),
      ],
      child: const ResumeCraftApp(),
    ),
  );
}

class ResumeCraftApp extends StatelessWidget {
  const ResumeCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
