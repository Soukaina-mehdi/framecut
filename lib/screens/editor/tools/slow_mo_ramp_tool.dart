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

class SlowMoRampTool extends ConsumerStatefulWidget {
  const SlowMoRampTool({super.key});
  @override
  ConsumerState<SlowMoRampTool> createState() => _SlowMoRampToolState();
}

class _SlowMoRampToolState extends ConsumerState<SlowMoRampTool> {
  double _startSpeed = 1.0;
  double _endSpeed = 0.25;
  double _transitionPoint = 0.5;

  static const _speedOptions = [1.0, 0.75, 0.5, 0.25];
  static const _speedLabels = ['1x', '0.75x', '0.5x', '0.25x'];

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
            const Icon(Icons.slow_motion_video, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            const Text('Slow-Mo Ramp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF1A1A1A),
            ),
            child: CustomPaint(
              painter: _RampGraphPainter(_startSpeed, _endSpeed, _transitionPoint, AppTheme.accentColor),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Start Speed', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 4),
              Row(children: List.generate(4, (i) => GestureDetector(
                onTap: () => setState(() => _startSpeed = _speedOptions[i]),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _startSpeed == _speedOptions[i] ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                    border: Border.all(color: _startSpeed == _speedOptions[i] ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(_speedLabels[i], style: TextStyle(color: _startSpeed == _speedOptions[i] ? Colors.white : Colors.white54, fontSize: 10)),
                ),
              ))),
            ])),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('End Speed', style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 4),
              Row(children: List.generate(4, (i) => GestureDetector(
                onTap: () => setState(() => _endSpeed = _speedOptions[i]),
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _endSpeed == _speedOptions[i] ? AppTheme.accentColor : const Color(0xFF1A1A1A),
                    border: Border.all(color: _endSpeed == _speedOptions[i] ? AppTheme.accentColor : const Color(0xFF2A2A2A)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(_speedLabels[i], style: TextStyle(color: _endSpeed == _speedOptions[i] ? Colors.white : Colors.white54, fontSize: 10)),
                ),
              ))),
            ])),
          ]),
          const SizedBox(height: 6),
          SliderRow(
            label: 'Transition',
            value: _transitionPoint,
            min: 0.1,
            max: 0.9,
            onChanged: (v) => setState(() => _transitionPoint = v),
            displayValue: '${(_transitionPoint * 100).round()}%',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () {
                ref.read(editorProvider.notifier).addEffect(Effect(
                  id: const Uuid().v4(),
                  typeName: 'slowMoRamp',
                  params: {'startSpeed': _startSpeed, 'endSpeed': _endSpeed, 'transitionPoint': _transitionPoint},
                ));
              },
              child: const Text('Apply Speed Ramp'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RampGraphPainter extends CustomPainter {
  final double startSpeed;
  final double endSpeed;
  final double transitionPoint;
  final Color color;

  const _RampGraphPainter(this.startSpeed, this.endSpeed, this.transitionPoint, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 2..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = color.withOpacity(0.15)..style = PaintingStyle.fill;

    double speedToY(double speed) => size.height - (speed / 1.0) * (size.height - 10) - 5;

    final startY = speedToY(startSpeed);
    final endY = speedToY(endSpeed);
    final transX = transitionPoint * size.width;

    final path = Path()
      ..moveTo(0, startY)
      ..cubicTo(transX * 0.6, startY, transX * 0.4, endY, transX, endY)
      ..lineTo(size.width, endY);

    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, startY), 4, dotPaint);
    canvas.drawCircle(Offset(size.width, endY), 4, dotPaint);
    canvas.drawCircle(Offset(transX, endY), 3, dotPaint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
