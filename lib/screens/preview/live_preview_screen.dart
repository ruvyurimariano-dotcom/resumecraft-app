import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../builder/resume_builder_screen.dart';
import '../customization/customization_sheet.dart';
import '../templates/template_gallery_screen.dart';
import '../ats/ats_checker_screen.dart';
import '../export/export_screen.dart';
import '../../services/share_service.dart';
import 'resume_canvas_widget.dart';

class LivePreviewScreen extends StatefulWidget {
  const LivePreviewScreen({super.key});

  @override
  State<LivePreviewScreen> createState() => _LivePreviewScreenState();
}

class _LivePreviewScreenState extends State<LivePreviewScreen> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() => _currentScale = 1.0);
  }

  void _zoomIn() {
    setState(() {
      _currentScale = (_currentScale + 0.2).clamp(0.6, 2.5);
      _transformationController.value =
          Matrix4.diagonal3Values(_currentScale, _currentScale, 1.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentScale = (_currentScale - 0.2).clamp(0.6, 2.5);
      _transformationController.value =
          Matrix4.diagonal3Values(_currentScale, _currentScale, 1.0);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<ResumeProvider>();
    final resume = provider.activeResume;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF090D16) : const Color(0xFFE2E8F0),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        title: Text(resume.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.fact_check_outlined),
            tooltip: 'ATS Checker',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AtsCheckerScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Resume',
            onPressed: () =>
                ShareService.shareResumePdf(context: context, resume: resume),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export PDF',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ExportScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Controls Bar (Zoom & Page Counter)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isDark ? AppColors.surfaceDark : Colors.white,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Page 1 of 1',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.zoom_out_rounded, size: 20),
                    onPressed: _zoomOut,
                    tooltip: 'Zoom Out',
                  ),
                  Text(
                    '${(_currentScale * 100).toInt()}%',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_in_rounded, size: 20),
                    onPressed: _zoomIn,
                    tooltip: 'Zoom In',
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    onPressed: _resetZoom,
                    tooltip: 'Reset Zoom',
                  ),
                ],
              ),
            ),

            // Zoomable Interactive Canvas
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.5,
                  maxScale: 2.5,
                  boundaryMargin: const EdgeInsets.all(40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: ResumeCanvasWidget(resume: resume),
                  ),
                ),
              ),
            ),

            // Bottom Toolbar Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity( 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _toolbarItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ResumeBuilderScreen(),
                        ),
                      );
                    },
                  ),
                  _toolbarItem(
                    icon: Icons.grid_view_outlined,
                    label: 'Template',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TemplateGalleryScreen(
                              isSelectionMode: true),
                        ),
                      );
                    },
                  ),
                  _toolbarItem(
                    icon: Icons.palette_outlined,
                    label: 'Style',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => const CustomizationSheet(),
                      );
                    },
                  ),
                  _toolbarItem(
                    icon: Icons.fact_check_outlined,
                    label: 'ATS Check',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AtsCheckerScreen(),
                        ),
                      );
                    },
                  ),
                  _toolbarItem(
                    icon: Icons.file_download_rounded,
                    label: 'Export',
                    isPrimary: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ExportScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbarItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isPrimary ? AppColors.primary : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
                color: isPrimary ? AppColors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
