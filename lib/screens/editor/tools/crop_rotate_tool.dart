import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/editor_provider.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';
import '../../../models/clip.dart';

class CropRotateTool extends ConsumerStatefulWidget {
  const CropRotateTool({super.key});
  @override
  ConsumerState<CropRotateTool> createState() => _CropRotateToolState();
}

class _CropRotateToolState extends ConsumerState<CropRotateTool> {
  String _aspectRatio = 'Original';
  double _rotation = 0.0;
  bool _flipH = false;
  bool _flipV = false;

  static const _ratios = [
    'Original', '9:16', '16:9', '1:1', '4:3', '2.35:1',
  ];

  void _commit() {
    final state = ref.read(editorProvider);
    final clip = state.selectedClip;
    final idx = state.selectedClipIndex;
    if (clip == null || idx < 0) return;
    ref.read(editorProvider.notifier).updateClip(
          idx,
          clip.copyWith(
            aspectRatioPreset: _aspectRatio,
            rotation: _rotation,
            flipHorizontal: _flipH,
            flipVertical: _flipV,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Crop & Rotate'),
          // Aspect ratios
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _ratios.map((r) {
                final sel = _aspectRatio == r;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () { setState(() => _aspectRatio = r); _commit(); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.accent.withOpacity(0.15)
                            : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: sel
                                ? AppTheme.accent
                                : const Color(0xFF2A2A2A)),
                      ),
                      child: Text(r,
                          style: TextStyle(
                              color:
                                  sel ? AppTheme.accent : Colors.white70,
                              fontSize: 11)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          // Rotation controls
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.rotate_left,
                    color: Colors.white70, size: 20),
                onPressed: () {
                  setState(() => _rotation = (_rotation - 90).clamp(-180, 180));
                  _commit();
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SliderRow(
                  label: 'Rotate',
                  value: _rotation,
                  min: -180,
                  max: 180,
                  displayFormat: (v) => '${v.toStringAsFixed(0)}°',
                  onChanged: (v) { setState(() => _rotation = v); _commit(); },
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.rotate_right,
                    color: Colors.white70, size: 20),
                onPressed: () {
                  setState(() => _rotation = (_rotation + 90).clamp(-180, 180));
                  _commit();
                },
              ),
            ],
          ),
          // Flip buttons
          Row(
            children: [
              _flipBtn(Icons.flip, 'Flip H', _flipH,
                  () { setState(() => _flipH = !_flipH); _commit(); }),
              const SizedBox(width: 8),
              _flipBtn(Icons.flip, 'Flip V', _flipV,
                  () { setState(() => _flipV = !_flipV); _commit(); },
                  rotate90: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _flipBtn(IconData icon, String label, bool active,
      VoidCallback onTap, {bool rotate90 = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active
              ? AppTheme.accent.withOpacity(0.15)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? AppTheme.accent : const Color(0xFF2A2A2A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: rotate90 ? 1.5708 : 0,
              child: Icon(icon,
                  size: 14,
                  color: active ? AppTheme.accent : Colors.white60),
            ),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: active ? AppTheme.accent : Colors.white60,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
