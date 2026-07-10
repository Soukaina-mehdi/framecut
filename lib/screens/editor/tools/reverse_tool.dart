import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../models/clip.dart';
import '../../../models/audio_track.dart';
import '../../../models/text_overlay.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';

class ReverseTool extends ConsumerStatefulWidget {
  const ReverseTool({super.key});
  @override
  ConsumerState<ReverseTool> createState() => _ReverseToolState();
}

class _ReverseToolState extends ConsumerState<ReverseTool> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final clip = state.selectedClip;
    final isReversed = clip?.reversed ?? false;

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.swap_horiz, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Reverse Clip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const Spacer(),
          Center(
            child: AnimatedBuilder(
              animation: _flipAnim,
              builder: (context, child) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_flipAnim.value * 3.14159),
                child: Icon(Icons.flip, size: 48, color: isReversed ? AppTheme.accentColor : Colors.white38),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2A2A2A)),
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF1A1A1A),
              ),
              child: Text(
                isReversed ? '⏪  Reversed' : '▶  Normal',
                style: TextStyle(color: isReversed ? AppTheme.accentColor : Colors.white60, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isReversed ? Colors.grey.shade800 : AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: clip == null ? null : () {
                _animController.forward(from: 0);
                ref.read(editorProvider.notifier).updateClip(clip.copyWith(reversed: !isReversed));
              },
              child: Text(isReversed ? 'Restore Normal' : 'Reverse Clip'),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
