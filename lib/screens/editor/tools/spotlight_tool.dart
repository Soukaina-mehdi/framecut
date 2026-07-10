import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../widgets/slider_row.dart';
import '../../../widgets/section_header.dart';

class SpotlightTool extends ConsumerStatefulWidget {
  const SpotlightTool({super.key});

  @override
  ConsumerState<SpotlightTool> createState() => _SpotlightToolState();
}

class _SpotlightToolState extends ConsumerState<SpotlightTool> {
  double _radius = 0.4;
  double _intensity = 0.8;
  double _feather = 0.5;
  double _x = 0.5;
  double _y = 0.5;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'spotlight',
      params: {
        'radius': _radius,
        'intensity': _intensity,
        'feather': _feather,
        'x': _x,
        'y': _y,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(title: 'Spotlight'),
                  SliderRow(
                    label: 'Radius',
                    value: _radius,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() => _radius = v);
                      _apply();
                    },
                  ),
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
                  SliderRow(
                    label: 'Center X',
                    value: _x,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() => _x = v);
                      _apply();
                    },
                  ),
                  SliderRow(
                    label: 'Center Y',
                    value: _y,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (v) {
                      setState(() => _y = v);
                      _apply();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Preview',
                  style: TextStyle(color: Colors.white38, fontSize: 10)),
              const SizedBox(height: 6),
              CustomPaint(
                size: const Size(72, 72),
                painter: _SpotlightPreviewPainter(
                  x: _x,
                  y: _y,
                  radius: _radius,
                  intensity: _intensity,
                  feather: _feather,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpotlightPreviewPainter extends CustomPainter {
  final double x, y, radius, intensity, feather;
  _SpotlightPreviewPainter({
    required this.x,
    required this.y,
    required this.radius,
    required this.intensity,
    required this.feather,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      Paint()..color = const Color(0xFF1A1A1A),
    );

    final cx = x * size.width;
    final cy = y * size.height;
    final r = radius * (size.width / 2);
    final inner = r * (1.0 - feather.clamp(0.05, 0.95));

    final gradient = RadialGradient(
      colors: [
        Colors.white.withOpacity(intensity * 0.9),
        Colors.transparent,
      ],
      stops: [inner / r.clamp(1, double.infinity), 1.0],
    ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r.clamp(1, size.width)));

    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black.withOpacity(0.7));

    canvas.drawCircle(
      Offset(cx, cy),
      r.clamp(1, size.width / 1.2),
      Paint()..shader = gradient,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      3,
      Paint()..color = Colors.white70,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(6)),
      Paint()
        ..color = const Color(0xFF2A2A2A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPreviewPainter old) =>
      old.x != x ||
      old.y != y ||
      old.radius != radius ||
      old.intensity != intensity ||
      old.feather != feather;
}
