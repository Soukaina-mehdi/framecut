import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../app/theme.dart';

class ExportCompleteScreen extends StatelessWidget {
  final String outputPath;
  const ExportCompleteScreen({super.key, required this.outputPath});

  Future<void> _shareVideo(BuildContext context) async {
    await Share.shareXFiles([XFile(outputPath)], text: 'Check out my video made with FrameCut!');
  }

  void _saveToGallery(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saving to gallery…')));
  }

  Widget _actionButton({required String label, required VoidCallback onTap, bool primary = false}) {
    return SizedBox(
      width: double.infinity, height: 50,
      child: primary
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111111),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'DM Sans')),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF111111),
                side: const BorderSide(color: Color(0xFFE5E5E5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, fontFamily: 'DM Sans')),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(children: [
            const Spacer(flex: 2),

            // Checkmark circle
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),

            const Text('Export Complete!', style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w700,
              color: Color(0xFF111111), fontFamily: 'DM Sans',
            )),
            const SizedBox(height: 10),
            const Text('Your video has been rendered and is ready to share.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF888888), fontFamily: 'DM Sans', height: 1.5),
            ),
            const SizedBox(height: 16),

            // File path
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(children: [
                const Icon(Icons.insert_drive_file_outlined, size: 16, color: Color(0xFF888888)),
                const SizedBox(width: 8),
                Expanded(child: Text(outputPath,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF888888), fontFamily: 'DM Sans'),
                )),
              ]),
            ),

            const Spacer(flex: 2),

            // Buttons
            _actionButton(label: 'Share Video', onTap: () => _shareVideo(context), primary: true),
            const SizedBox(height: 10),
            _actionButton(label: 'Save to Gallery', onTap: () => _saveToGallery(context)),
            const SizedBox(height: 10),
            _actionButton(label: 'Back to Editor', onTap: () => context.pop()),
            const SizedBox(height: 10),
            _actionButton(label: 'New Project', onTap: () => context.go('/projects')),

            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}
