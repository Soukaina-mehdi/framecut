import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

class VignetteTool extends ConsumerStatefulWidget {
  const VignetteTool({super.key});

  @override
  ConsumerState<VignetteTool> createState() => _VignetteToolState();
}

class _VignetteToolState extends ConsumerState<VignetteTool> {
  double _intensity = 0.5;
  double _feather = 0.5;
  bool _invert = false;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'vignette',
      params: {
        'intensity': _intensity,
        'feather': _feather,
        'invert': _invert,
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Vignette'),
                SliderRow(
                  label: 'Intensity',
                  value: _intensity,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (v) {
                    setState(() => _intensity = v);
                    _apply();
                  },
                ),
                SliderRow(
                  label: 'Feather',
                  value: _feather,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (v) {
                    setState(() => _feather = v);
                    _apply();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Spotlight Mode',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const Spacer(),
                    Switch(
                      value: _invert,
                      onChanged: (v) {
                        setState(() => _invert = v);
                        _apply();
                      },
                      activeColor: AppTheme.accent,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Preview',
                  style: TextStyle(color: Colors.white38, fontSize: 10)),
              const SizedBox(height: 6),
              CustomPaint(
                size: const Size(72, 72),
                painter: _VignettePreviewPainter(
                  intensity: _intensity,
                  feather: _feather,
                  invert: _invert,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VignettePreviewPainter extends CustomPainter {
  final double intensity;
  final double feather;
  final bool invert;
  _VignettePreviewPainter(
      {required this.intensity, required this.feather, required this.invert});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    canvas.drawOval(
        Offset.zero & size,
        Paint()..color = const Color(0xFF1E1E1E));

    final inner = radius * (1 - feather.clamp(0.1, 0.9));
    final gradient = RadialGradient(
      colors: invert
          ? [
              Colors.black.withOpacity(0),
              Colors.white.withOpacity(intensity * 0.8),
            ]
          : [
              Colors.black.withOpacity(0),
              Colors.black.withOpacity(intensity * 0.9),
            ],
      stops: [inner / radius, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawOval(
        Offset.zero & size,
        Paint()..shader = gradient);

    canvas.drawOval(
        Offset.zero & size,
        Paint()
          ..color = const Color(0xFF2A2A2A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(_VignettePreviewPainter old) =>
      old.intensity != intensity ||
      old.feather != feather ||
      old.invert != invert;
}
