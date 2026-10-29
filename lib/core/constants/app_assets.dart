import 'package:flutter/material.dart';

/// Asset paths and preset icon constants for ResumeCraft.
class AppAssets {
  AppAssets._();

  // Preset avatar URLs or identifiers
  static const List<String> presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
  ];

  // System Icons
  static const IconData resumeDocIcon = Icons.description_rounded;
  static const IconData sparklerIcon = Icons.auto_awesome_rounded;
  static const IconData atsIcon = Icons.fact_check_rounded;
  static const IconData customizeIcon = Icons.palette_rounded;
  static const IconData exportIcon = Icons.file_download_rounded;
}
