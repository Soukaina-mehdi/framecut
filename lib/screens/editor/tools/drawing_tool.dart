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

class DrawingTool extends ConsumerStatefulWidget {
  const DrawingTool({super.key});
  @override
  ConsumerState<DrawingTool> createState() => _DrawingToolState();
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double brushSize;

  _DrawingPainter(this.strokes, this.color, this.brushSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = brushSize..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) path.lineTo(stroke[i].dx, stroke[i].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DrawingToolState extends ConsumerState<DrawingTool> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _current = [];
  double _brushSize = 5.0;
  Color _color = Colors.white;
  bool _eraser = false;

  static const _colors = [Colors.white, Colors.red, Colors.yellow, Colors.green, Colors.blue, Colors.purple];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);

    return Container(
      height: 220,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.draw, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Drawing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _strokes.clear()),
              child: const Icon(Icons.undo, color: Colors.white54, size: 18),
            ),
          ]),
          const SizedBox(height: 6),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2A2A2A)),
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFF1A1A1A),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: GestureDetector(
                  onPanStart: (d) => setState(() => _current = [d.localPosition]),
                  onPanUpdate: (d) => setState(() => _current.add(d.localPosition)),
                  onPanEnd: (_) => setState(() { _strokes.add(List.from(_current)); _current = []; }),
                  child: CustomPaint(
                    painter: _DrawingPainter([..._strokes, if (_current.isNotEmpty) _current], _eraser ? const Color(0xFF1A1A1A) : _color, _brushSize),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(trackHeight: 2, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5), activeTrackColor: AppTheme.accentColor, inactiveTrackColor: const Color(0xFF2A2A2A), thumbColor: AppTheme.accentColor),
              child: SizedBox(width: 100, child: Slider(value: _brushSize, min: 1, max: 20, onChanged: (v) => setState(() => _brushSize = v))),
            ),
            const SizedBox(width: 6),
            for (final c in _colors) GestureDetector(
              onTap: () => setState(() { _color = c; _eraser = false; }),
              child: Container(margin: const EdgeInsets.only(right: 4), width: 18, height: 18, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: _color == c && !_eraser ? Colors.white : Colors.transparent, width: 2))),
            ),
            GestureDetector(
              onTap: () => setState(() => _eraser = !_eraser),
              child: Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(border: Border.all(color: _eraser ? AppTheme.accentColor : const Color(0xFF2A2A2A)), borderRadius: BorderRadius.circular(4)),
                child: Icon(Icons.auto_fix_high, color: _eraser ? AppTheme.accentColor : Colors.white54, size: 14)),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'drawing',
                  params: {'color': '#${_color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}', 'brushSize': _brushSize.round()},
                ));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(4)),
                child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
