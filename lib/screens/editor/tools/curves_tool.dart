import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../providers/editor_provider.dart';
import '../../../models/effect.dart';
import '../../../app/theme.dart';
import '../../../widgets/section_header.dart';

const _channels = ['All', 'R', 'G', 'B'];
const _channelColors = [Colors.white, Colors.red, Colors.green, Colors.blue];

class CurvesTool extends ConsumerStatefulWidget {
  const CurvesTool({super.key});

  @override
  ConsumerState<CurvesTool> createState() => _CurvesToolState();
}

class _CurvesToolState extends ConsumerState<CurvesTool> {
  int _channelIdx = 0;
  List<Offset> _points = [
    const Offset(0.0, 1.0),
    const Offset(0.5, 0.5),
    const Offset(1.0, 0.0),
  ];
  int? _dragging;

  void _apply() {
    ref.read(editorProvider.notifier).addEffect(Effect(
      id: const Uuid().v4(),
      typeName: 'curves',
      params: {
        'points': _points.map((p) => [p.dx, p.dy]).toList(),
        'channel': _channels[_channelIdx].toLowerCase(),
      },
    ));
  }

  void _reset() {
    setState(() {
      _points = [
        const Offset(0.0, 1.0),
        const Offset(0.5, 0.5),
        const Offset(1.0, 0.0),
      ];
    });
    _apply();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SectionHeader(title: 'Curves'),
              const Spacer(),
              ..._channels.asMap().entries.map((e) => GestureDetector(
                    onTap: () => setState(() => _channelIdx = e.key),
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _channelIdx == e.key
                            ? _channelColors[e.key].withOpacity(0.85)
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: Text(e.value,
                          style: TextStyle(
                              color: _channelIdx == e.key
                                  ? Colors.black
                                  : Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  )),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _reset,
                child: const Text('Reset',
                    style: TextStyle(color: Colors.white38, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(builder: (ctx, box) {
              final w = box.maxWidth;
              final h = box.maxHeight;
              return GestureDetector(
                onPanStart: (d) {
                  final local = d.localPosition;
                  for (int i = 0; i < _points.length; i++) {
                    final px = _points[i].dx * w;
                    final py = _points[i].dy * h;
                    if ((local - Offset(px, py)).distance < 18) {
                      setState(() => _dragging = i);
                      return;
                    }
                  }
                },
                onPanUpdate: (d) {
                  if (_dragging == null) return;
                  setState(() {
                    final p = d.localPosition;
                    _points[_dragging!] = Offset(
                      (p.dx / w).clamp(0.0, 1.0),
                      (p.dy / h).clamp(0.0, 1.0),
                    );
                  });
                  _apply();
                },
                onPanEnd: (_) => setState(() => _dragging = null),
                child: CustomPaint(
                  size: Size(w, h),
                  painter: _CurvesPainter(
                    points: _points,
                    color: _channelColors[_channelIdx],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CurvesPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  _CurvesPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Offset.zero & size, const Radius.circular(8)),
        bg);

    final grid = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..strokeWidth = 0.5;
    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      final y = size.height * i / 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final diag = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, 0), diag);

    final sorted = [...points]..sort((a, b) => a.dx.compareTo(b.dx));
    if (sorted.length >= 2) {
      final path = Path();
      path.moveTo(sorted[0].dx * size.width, sorted[0].dy * size.height);
      for (int i = 1; i < sorted.length; i++) {
        path.lineTo(sorted[i].dx * size.width, sorted[i].dy * size.height);
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = color.withOpacity(0.9)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke);
    }

    for (final p in points) {
      canvas.drawCircle(
          Offset(p.dx * size.width, p.dy * size.height),
          6,
          Paint()..color = color);
      canvas.drawCircle(
          Offset(p.dx * size.width, p.dy * size.height),
          6,
          Paint()
            ..color = Colors.black54
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
    }
  }

  @override
  bool shouldRepaint(_CurvesPainter old) =>
      old.points != points || old.color != color;
}
